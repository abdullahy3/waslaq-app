import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:waslaq_app/core/api/medusa_client.dart';
import 'package:waslaq_app/core/auth/auth_notifier.dart';
import 'package:waslaq_app/core/auth/firebase_service.dart';
import 'package:waslaq_app/i18n/strings.g.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';
import 'package:waslaq_app/shared/widgets/biometric_guard.dart';
import 'package:waslaq_app/core/providers/preferences_provider.dart';
import 'package:waslaq_app/features/account/data/models/social_settings_model.dart';
import 'package:waslaq_app/features/account/providers/account_providers.dart';

@RoutePage()
class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isBiometricSupported = false;

  bool _isChangingEmail = false;
  bool _showEmailForm = false;
  final TextEditingController _emailController = TextEditingController();

  UserSocialSettingsModel? _socialSettings;
  bool _isLoadingSettings = true;
  bool _isDeleting = false;
  DateTime? _deletionDate;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _loadSettings();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final supported = canCheck || await _auth.isDeviceSupported();
      setState(() {
        _canCheckBiometrics = canCheck;
        _isBiometricSupported = supported;
      });
    } catch (_) {}
  }

  Future<void> _loadSettings() async {
    try {
      final map = await ref.read(accountRepositoryProvider).getSocialSettings();
      setState(() {
        _socialSettings = UserSocialSettingsModel.fromJson(map);
        _isLoadingSettings = false;
      });
    } catch (_) {
      setState(() => _isLoadingSettings = false);
    }
  }

  Future<void> _updateSocialSettings(UserSocialSettingsModel newSettings) async {
    try {
      setState(() => _socialSettings = newSettings);
      await ref.read(accountRepositoryProvider).updateSocialSettings(newSettings.toJson());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update notifications: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  Future<void> _changeEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() => _isChangingEmail = true);
    try {
      await MedusaClient.instance.post('/store/custom/auth/change-email', data: {'email': email});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Verification link sent to new email.'), backgroundColor: context.colors.success),
      );
      setState(() {
        _showEmailForm = false;
        _emailController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change email: $e'), backgroundColor: context.colors.error),
      );
    } finally {
      if (mounted) setState(() => _isChangingEmail = false);
    }
  }

  Future<void> _sendPasswordReset(String email) async {
    if (email.isEmpty) return;
    try {
      await FirebaseService.sendPasswordResetEmail(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Reset link sent to $email'), backgroundColor: context.colors.success),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset link: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  Future<void> _toggleBiometricLock(bool enabled) async {
    final prefs = ref.read(preferencesProvider);
    if (enabled) {
      BiometricGuard.externalAuthInProgress = true;
      try {
        final didAuth = await _auth.authenticate(
          localizedReason: 'Confirm with fingerprint or Face ID to enable app lock',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (didAuth) {
          await ref.read(preferencesProvider.notifier).update(prefs.copyWith(biometricLock: true));
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Biometric authentication failed: $e'), backgroundColor: context.colors.error),
        );
      } finally {
        BiometricGuard.externalAuthInProgress = false;
      }
    } else {
      await ref.read(preferencesProvider.notifier).update(prefs.copyWith(biometricLock: false));
    }
  }

  Future<void> _togglePurchaseConfirmation(bool enabled) async {
    final prefs = ref.read(preferencesProvider);
    if (enabled) {
      BiometricGuard.externalAuthInProgress = true;
      try {
        final didAuth = await _auth.authenticate(
          localizedReason: 'Confirm with fingerprint or Face ID to enable purchase confirmation',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (didAuth) {
          await ref.read(preferencesProvider.notifier).update(prefs.copyWith(purchaseConfirmation: true));
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Biometric authentication failed: $e'), backgroundColor: context.colors.error),
        );
      } finally {
        BiometricGuard.externalAuthInProgress = false;
      }
    } else {
      await ref.read(preferencesProvider.notifier).update(prefs.copyWith(purchaseConfirmation: false));
    }
  }

  Future<void> _deleteAccount() async {
    setState(() => _isDeleting = true);
    try {
      await ref.read(accountRepositoryProvider).deleteAccount();
      setState(() {
        _deletionDate = DateTime.now().add(const Duration(days: 30));
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Account deletion scheduled successfully.'), backgroundColor: context.colors.success),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e'), backgroundColor: context.colors.error),
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  Future<void> _cancelDeletion() async {
    setState(() => _isDeleting = true);
    try {
      await ref.read(accountRepositoryProvider).cancelDeletion();
      setState(() {
        _deletionDate = null;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Account deletion cancelled.'), backgroundColor: context.colors.success),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel deletion: $e'), backgroundColor: context.colors.error),
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  void _showDeleteConfirmation() {
    final s = t.settings;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(s.deleteAccount, style: TextStyle(color: Colors.red)),
        content: const Text('Are you absolutely sure you want to request account deletion? Your data will be hidden and permanently deleted after 30 days.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(s.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              _showSecondDeleteConfirmation();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showSecondDeleteConfirmation() {
    final s = t.settings;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(s.permanentAction, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text('This is your last warning. Once submitted, your profile will be scheduled for deletion. You will have 30 days to cancel this request.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep Account')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              _deleteAccount();
            },
            child: Text(s.deleteAccount),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = t.settings;
    final authState = ref.watch(authNotifierProvider);
    final email = authState.maybeWhen(
      authenticated: (_, mail, __, ___, ____) => mail ?? '',
      orElse: () => '',
    );
    final prefs = ref.watch(preferencesProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(s.accountScreenTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ─── EMAIL CARD ───
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.accountEmailLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(email.isNotEmpty ? email : s.notSet, style: TextStyle(color: context.colors.textSecondary)),
                  const SizedBox(height: 12),
                  if (!_showEmailForm)
                    OutlinedButton(
                      onPressed: () => setState(() => _showEmailForm = true),
                      child: const Text('Change Email'),
                    )
                  else ...[
                    TextField(
                      controller: _emailController,
                      style: TextStyle(color: context.colors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'New Email',
                        hintText: 'Enter new email address',
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _isChangingEmail ? null : _changeEmail,
                          style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary, foregroundColor: Colors.white),
                          child: _isChangingEmail
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Submit'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => setState(() => _showEmailForm = false),
                          child: Text(s.cancel),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ─── PASSWORD CARD ───
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.accountPasswordLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(s.accountPasswordSub, style: TextStyle(color: context.colors.textMuted, fontSize: 13)),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: email.isEmpty ? null : () => _sendPasswordReset(email),
                    child: Text(s.resetLinkButton),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ─── CONNECTED ACCOUNTS ───
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.accountConnectedLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.g_mobiledata, color: Colors.blue, size: 30),
                      const SizedBox(width: 8),
                      const Text('Google', style: TextStyle(fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Chip(
                        label: Text(s.connected, style: TextStyle(color: Colors.white, fontSize: 11)),
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ─── BIOMETRIC LOCK CARD ───
          if (_isBiometricSupported) ...[
            Card(
              color: context.colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: context.colors.border),
              ),
              child: SwitchListTile(
                activeColor: context.colors.primary,
                title: Text(s.accountBiometric, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text(s.accountBiometricSub, style: TextStyle(fontSize: 12)),
                value: prefs.biometricLock,
                onChanged: _toggleBiometricLock,
              ),
            ),
            const SizedBox(height: 16),

            // ─── PURCHASE CONFIRMATION CARD ───
            Card(
              color: context.colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: context.colors.border),
              ),
              child: SwitchListTile(
                activeColor: context.colors.primary,
                title: Text(s.accountPurchaseConfirm, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text(s.accountPurchaseConfirmSub, style: TextStyle(fontSize: 12)),
                value: prefs.purchaseConfirmation,
                onChanged: _togglePurchaseConfirmation,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ─── ACTIVE SESSIONS CARD ───
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Sessions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('Signed in on this device', style: TextStyle(color: context.colors.textMuted, fontSize: 13)),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
                    child: const Text('Sign Out From All Devices'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ─── LOGIN NOTIFICATIONS CARD ───
          if (!_isLoadingSettings && _socialSettings != null) ...[
            Card(
              color: context.colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: context.colors.border),
              ),
              child: SwitchListTile(
                activeColor: context.colors.primary,
                title: Text(s.accountLoginNotif, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text(s.accountLoginNotifSub, style: TextStyle(fontSize: 12)),
                value: _socialSettings!.loginNotifications,
                onChanged: (val) {
                  _updateSocialSettings(_socialSettings!.copyWith(loginNotifications: val));
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ─── DELETE ACCOUNT CARD ───
          Card(
            color: Colors.red.withOpacity(0.02),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.red, width: 0.8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.deleteAccount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red)),
                  const SizedBox(height: 6),
                  Text(s.permanentAction, style: TextStyle(color: Colors.red, fontSize: 12)),
                  const SizedBox(height: 12),
                  if (_deletionDate == null)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      onPressed: _isDeleting ? null : _showDeleteConfirmation,
                      child: Text(s.deleteAccount),
                    )
                  else ...[
                    Text('Deletion scheduled for: ${_deletionDate!.toLocal().toString().split(' ')[0]}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary),
                      onPressed: _isDeleting ? null : _cancelDeletion,
                      child: const Text('Cancel Deletion'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
