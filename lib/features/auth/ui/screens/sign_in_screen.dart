import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/auth_notifier.dart';
import '../../../../core/auth/auth_state.dart';
import '../../../../core/auth/firebase_service.dart';
import '../../../../core/config/app_config.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';

@RoutePage()
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please agree to the Terms of Use and Privacy Policy to continue.'),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }
    await ref.read(authNotifierProvider.notifier).signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  Future<void> _googleSignIn() async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  // Federated (Google/Facebook) accounts have no password — checked via the
  // backend so the dialog can steer them to the right button instead of sending
  // a reset that would silently add a password. Returns the provider label, or
  // null if a password reset is appropriate (or the check can't be made).
  Future<String?> _federatedProviderFor(String email) async {
    try {
      final resp = await Dio().post(
        '${AppConfig.apiBase}/store/custom/auth/check-provider',
        data: {'email': email},
        options: Options(headers: {'x-publishable-api-key': AppConfig.publishableKey}),
      );
      final data = resp.data;
      if (data is Map && data['canReset'] == false && data['provider'] != null) {
        final p = data['provider'];
        if (p == 'google.com') return 'Google';
        if (p == 'facebook.com') return 'Facebook';
        return 'social login';
      }
    } catch (_) {
      // fail open — fall back to the normal reset
    }
    return null;
  }

  Future<void> _showForgotPasswordDialog() async {
    final emailCtrl = TextEditingController(text: _emailController.text.trim());
    await showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        bool busy = false;
        String? info;
        return StatefulBuilder(
          builder: (dialogCtx, setLocal) {
            Future<void> submit() async {
              final email = emailCtrl.text.trim();
              if (email.isEmpty) {
                setLocal(() => info = 'Please enter your email.');
                return;
              }
              setLocal(() {
                busy = true;
                info = null;
              });

              final federated = await _federatedProviderFor(email);
              if (federated != null) {
                setLocal(() {
                  busy = false;
                  info = 'This account uses $federated sign-in — use the '
                      '$federated button to sign in.';
                });
                return;
              }

              try {
                await FirebaseService.sendPasswordResetEmail(email);
              } catch (_) {
                // Anti-enumeration: don't reveal whether the email exists.
              }
              if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('If an account exists, a reset link was sent to $email.'),
                    backgroundColor: context.colors.success,
                  ),
                );
              }
            }

            return AlertDialog(
              title: const Text('Reset password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Enter your email and we\'ll send you a reset link.'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (info != null) ...[
                    const SizedBox(height: 12),
                    Text(info!, style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: busy ? null : () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: busy ? null : submit,
                  child: busy
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text('Send link'),
                ),
              ],
            );
          },
        );
      },
    );
    emailCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      next.maybeWhen(
        authenticated: (customerId, email, displayName, avatarUrl, username) {
          context.router.replaceAll([const HomeRoute()]);
        },
        error: (message) {
          if (message == 'Sign-in cancelled.') return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: context.colors.error,
            ),
          );
        },
        orElse: () {},
      );
    });

    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                // Logo / title
                Text(
                  'WaslaQ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.primary,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sign in to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 40),

                // ── Google sign-in button ──────────────────────────────
                OutlinedButton(
                  onPressed: isLoading ? null : _googleSignIn,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    side: BorderSide(color: context.colors.border, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/google_logo.svg',
                        width: 22,
                        height: 22,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // ── Divider ────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(child: Divider(color: context.colors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(
                            color: context.colors.textMuted, fontSize: 13),
                      ),
                    ),
                    Expanded(child: Divider(color: context.colors.border)),
                  ],
                ),

                SizedBox(height: 20),

                // ── Email ──────────────────────────────────────────────
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(color: context.colors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined,
                        color: context.colors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: context.colors.primary, width: 2),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Email is required' : null,
                ),
                SizedBox(height: 16),

                // ── Password ───────────────────────────────────────────
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscure,
                  style: TextStyle(color: context.colors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline,
                        color: context.colors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: context.colors.textSecondary,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: context.colors.primary, width: 2),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Password is required' : null,
                ),

                // ── Forgot password ────────────────────────────────────
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: isLoading ? null : _showForgotPasswordDialog,
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: context.colors.primary, fontSize: 13),
                    ),
                  ),
                ),

                SizedBox(height: 4),

                // ── Terms Agreement Checkbox ────────────────────────────
                _TermsCheckbox(
                  value: _agreedToTerms,
                  onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                  onTermsTap: () => context.router.push(const TermsRoute()),
                  onPrivacyTap: () => context.router.push(const PrivacyPolicyRoute()),
                ),

                SizedBox(height: 20),

                // ── Sign in button ─────────────────────────────────────
                FilledButton(
                  onPressed: isLoading ? null : _login,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          'Sign In',
                          style:
                              TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),

                SizedBox(height: 20),

                // ── Sign up link ───────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: context.colors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => context.router.push(const SignUpRoute()),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: context.colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared reusable widget — shown on sign-in, sign-up, and checkout.
class _TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  const _TermsCheckbox({
    required this.value,
    required this.onChanged,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: context.colors.primary,
            side: BorderSide(color: context.colors.border, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: context.colors.textSecondary, fontSize: 13, height: 1.5),
              children: [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Use',
                  style: TextStyle(
                    color: context.colors.primaryLight,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTermsTap,
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: context.colors.primaryLight,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onPrivacyTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
