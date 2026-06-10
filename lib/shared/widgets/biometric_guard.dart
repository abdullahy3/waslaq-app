import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:waslaq_app/core/providers/preferences_provider.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';

/// WhatsApp-style biometric lock guard.
///
/// Wraps the entire app. When [biometricLock] is enabled in preferences:
/// - On cold start → shows fingerprint prompt immediately.
/// - When the user backgrounds the app and comes back → shows fingerprint prompt.
/// - After successful scan → app unlocks, no re-prompt.
///
/// ## Samsung One UI Loop Prevention (3-Layer Defense)
///
/// On Samsung Galaxy devices (especially One UI 6+), the native biometric dialog
/// causes complex lifecycle event sequences that can trigger infinite auth loops.
/// This guard uses three independent safeguards:
///
/// 1. **`_checkingAuth` flag** — Ignores paused/resumed events while our own
///    biometric dialog is visible.
/// 2. **`externalAuthInProgress` static flag** — Ignores paused/resumed events
///    while another widget (e.g. settings screen) is showing a biometric prompt.
/// 3. **`_lastUnlockTime` cooldown** — After a successful unlock, ignores ALL
///    lifecycle events for 2 seconds to absorb Samsung's extra lifecycle chatter.
class BiometricGuard extends ConsumerStatefulWidget {
  final Widget child;

  const BiometricGuard({super.key, required this.child});

  /// Global flag: set to `true` when any OTHER widget (e.g. settings screen)
  /// is showing a biometric prompt via [LocalAuthentication]. This prevents
  /// BiometricGuard from misinterpreting the resulting Android lifecycle
  /// pause/resume as a genuine background event.
  ///
  /// Usage from any widget:
  /// ```dart
  /// BiometricGuard.externalAuthInProgress = true;
  /// try {
  ///   await _auth.authenticate(...);
  /// } finally {
  ///   BiometricGuard.externalAuthInProgress = false;
  /// }
  /// ```
  static bool externalAuthInProgress = false;

  @override
  ConsumerState<BiometricGuard> createState() => _BiometricGuardState();
}

class _BiometricGuardState extends ConsumerState<BiometricGuard>
    with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Whether the app content is locked behind biometric.
  bool _isLocked = false;

  /// Whether THIS widget's biometric dialog is currently showing.
  /// Set BEFORE the async authenticate() call and cleared AFTER it completes.
  bool _checkingAuth = false;

  /// Timestamp of the last successful unlock. Used to create a cooldown window
  /// that ignores lifecycle events, preventing Samsung One UI from re-locking
  /// the app due to extra lifecycle transitions after dialog dismissal.
  DateTime? _lastUnlockTime;

  /// Cooldown duration after a successful unlock. During this window, ALL
  /// pause/resume lifecycle events are ignored. 2 seconds is generous enough
  /// to absorb Samsung's post-dialog lifecycle chatter while still being short
  /// enough that the user won't notice if they quickly background the app.
  static const _unlockCooldown = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Synchronously read the preloaded biometric preference.
    // The preference is preloaded in main.dart before runApp() and injected
    // via ProviderScope.overrides, so ref.read() returns the correct value
    // on the very first frame — no async delay.
    final prefs = ref.read(preferencesProvider);
    debugPrint('[BiometricGuard] initState: biometricLock=${prefs.biometricLock}');
    if (prefs.biometricLock) {
      _isLocked = true;
      // Mark auth as active immediately to guard against any early lifecycle
      // events that might fire before the post-frame callback runs.
      _checkingAuth = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _doAuthenticate();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Returns true if we are within the post-unlock cooldown window.
  bool get _isInCooldown {
    if (_lastUnlockTime == null) return false;
    return DateTime.now().difference(_lastUnlockTime!) < _unlockCooldown;
  }

  /// Returns true if ANY biometric dialog is active (ours or external).
  bool get _isAnyAuthActive => _checkingAuth || BiometricGuard.externalAuthInProgress;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final prefs = ref.read(preferencesProvider);
    if (!prefs.biometricLock) return;

    debugPrint(
      '[BiometricGuard] Lifecycle: $state '
      '(locked=$_isLocked, checkingAuth=$_checkingAuth, '
      'externalAuth=${BiometricGuard.externalAuthInProgress}, '
      'cooldown=$_isInCooldown)',
    );

    if (state == AppLifecycleState.paused) {
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // GUARD 1: Any biometric dialog is active (ours or settings screen)
      // When the native fingerprint overlay appears, Android reports the
      // underlying Flutter activity as "paused" because it lost focus.
      // We must NOT treat this as a real background event.
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      if (_isAnyAuthActive) {
        debugPrint('[BiometricGuard] Ignored pause — biometric dialog active.');
        return;
      }

      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // GUARD 2: We're within the post-unlock cooldown window
      // Samsung One UI sends extra paused/resumed transitions after the
      // biometric dialog dismisses. Ignore them.
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      if (_isInCooldown) {
        debugPrint('[BiometricGuard] Ignored pause — unlock cooldown active.');
        return;
      }

      // ── Real background event (home button, screen off, task switcher) ──
      if (mounted) {
        setState(() {
          _isLocked = true;
        });
      }
      debugPrint('[BiometricGuard] App paused — locked.');

    } else if (state == AppLifecycleState.resumed) {
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // GUARD 1: Any biometric dialog is active
      // The dialog dismiss → resumed transition must be ignored.
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      if (_isAnyAuthActive) {
        debugPrint('[BiometricGuard] Ignored resume — biometric dialog active.');
        return;
      }

      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // GUARD 2: Post-unlock cooldown
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      if (_isInCooldown) {
        debugPrint('[BiometricGuard] Ignored resume — unlock cooldown active.');
        return;
      }

      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // GUARD 3: Only authenticate if we're actually locked
      // If the app is already unlocked, this is a spurious resume event.
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      if (!_isLocked) {
        debugPrint('[BiometricGuard] Ignored resume — already unlocked.');
        return;
      }

      // ── Genuine return from background while locked → authenticate ──
      debugPrint('[BiometricGuard] App resumed while locked — starting authentication.');
      _checkingAuth = true;
      _doAuthenticate();
    }
    // Note: AppLifecycleState.inactive is intentionally not handled.
    // Samsung sends inactive before paused; we only act on paused.
  }

  /// Core authentication logic. Caller MUST set [_checkingAuth] = true
  /// before calling this method.
  Future<void> _doAuthenticate() async {
    final prefs = ref.read(preferencesProvider);
    if (!prefs.biometricLock) {
      _checkingAuth = false;
      if (_isLocked && mounted) {
        setState(() => _isLocked = false);
      }
      return;
    }

    if (!_isLocked) {
      debugPrint('[BiometricGuard] Skip auth — already unlocked.');
      _checkingAuth = false;
      return;
    }

    debugPrint('[BiometricGuard] Showing biometric prompt...');

    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();

      if (canCheck && isSupported) {
        final didAuth = await _auth.authenticate(
          localizedReason: 'Unlock WaslaQ to continue',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
            useErrorDialogs: true,
          ),
        );

        if (didAuth && mounted) {
          _lastUnlockTime = DateTime.now();
          setState(() => _isLocked = false);
          debugPrint(
            '[BiometricGuard] ✓ Unlocked successfully. '
            'Cooldown active for ${_unlockCooldown.inSeconds}s.',
          );
        } else {
          debugPrint('[BiometricGuard] ✗ Auth denied/cancelled — staying locked.');
        }
      } else {
        // Device doesn't support biometrics — unlock to avoid permanent lock-out.
        debugPrint('[BiometricGuard] Biometrics unavailable — force unlock.');
        if (mounted) {
          setState(() => _isLocked = false);
        }
      }
    } catch (e) {
      debugPrint('[BiometricGuard] Auth exception: $e');
    } finally {
      _checkingAuth = false;
    }
  }

  /// Manual unlock button handler — used by the lock screen UI.
  Future<void> _checkAndAuthenticate() async {
    if (_checkingAuth) return; // Prevent double-tap
    _checkingAuth = true;
    await _doAuthenticate();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesProvider);

    // If biometric lock is disabled, render the app content normally
    if (!prefs.biometricLock) {
      return widget.child;
    }

    // If biometric lock is enabled and we are currently locked, show premium lock screen
    if (_isLocked) {
      final colors = context.colors;

      return Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // WaslaQ Logo & Branding
                  Text(
                    'WaslaQ',
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Palestinian Social Marketplace',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: colors.textSecondary,
                    ),
                  ),

                  const Spacer(),

                  // Lock Icon
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.primary.withOpacity(0.2),
                        width: 2.0,
                      ),
                    ),
                    child: Icon(
                      Icons.fingerprint,
                      size: 72.0,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // Lock Messages
                  Text(
                    'App Locked',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'Use fingerprint or biometric lock to unlock and continue browsing WaslaQ securely.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: colors.textSecondary,
                      height: 1.4,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Unlock Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 52.0,
                    child: ElevatedButton.icon(
                      onPressed: _checkAndAuthenticate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      icon: const Icon(Icons.lock_open, size: 20.0),
                      label: const Text(
                        'Unlock App',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48.0),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // App is unlocked — render child normally
    return widget.child;
  }
}
