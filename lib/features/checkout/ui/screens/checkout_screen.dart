import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../i18n/strings.g.dart';

import '../../../../core/auth/auth_notifier.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../data/models/checkout_model.dart';
import '../../providers/checkout_provider.dart';

// ─── Country data ──────────────────────────────────────────────────────────────

/// All world calling codes shown for digital-only carts.
/// Physical carts show Palestine only (+970 / +972).
const List<DropdownMenuItem<String>> _allCountryCodes = [
  DropdownMenuItem(value: '+970', child: Text('+970 🇵🇸')),
  DropdownMenuItem(value: '+972', child: Text('+972 🇮🇱')),
  DropdownMenuItem(value: '+962', child: Text('+962 🇯🇴')),
  DropdownMenuItem(value: '+20',  child: Text('+20 🇪🇬')),
  DropdownMenuItem(value: '+966', child: Text('+966 🇸🇦')),
  DropdownMenuItem(value: '+971', child: Text('+971 🇦🇪')),
  DropdownMenuItem(value: '+965', child: Text('+965 🇰🇼')),
  DropdownMenuItem(value: '+974', child: Text('+974 🇶🇦')),
  DropdownMenuItem(value: '+973', child: Text('+973 🇧🇭')),
  DropdownMenuItem(value: '+968', child: Text('+968 🇴🇲')),
  DropdownMenuItem(value: '+961', child: Text('+961 🇱🇧')),
  DropdownMenuItem(value: '+963', child: Text('+963 🇸🇾')),
  DropdownMenuItem(value: '+964', child: Text('+964 🇮🇶')),
  DropdownMenuItem(value: '+212', child: Text('+212 🇲🇦')),
  DropdownMenuItem(value: '+216', child: Text('+216 🇹🇳')),
  DropdownMenuItem(value: '+213', child: Text('+213 🇩🇿')),
  DropdownMenuItem(value: '+218', child: Text('+218 🇱🇾')),
  DropdownMenuItem(value: '+249', child: Text('+249 🇸🇩')),
  DropdownMenuItem(value: '+90',  child: Text('+90 🇹🇷')),
  DropdownMenuItem(value: '+98',  child: Text('+98 🇮🇷')),
  DropdownMenuItem(value: '+1',   child: Text('+1 🇺🇸')),
  DropdownMenuItem(value: '+44',  child: Text('+44 🇬🇧')),
  DropdownMenuItem(value: '+49',  child: Text('+49 🇩🇪')),
  DropdownMenuItem(value: '+33',  child: Text('+33 🇫🇷')),
  DropdownMenuItem(value: '+39',  child: Text('+39 🇮🇹')),
  DropdownMenuItem(value: '+34',  child: Text('+34 🇪🇸')),
  DropdownMenuItem(value: '+31',  child: Text('+31 🇳🇱')),
  DropdownMenuItem(value: '+46',  child: Text('+46 🇸🇪')),
  DropdownMenuItem(value: '+47',  child: Text('+47 🇳🇴')),
  DropdownMenuItem(value: '+45',  child: Text('+45 🇩🇰')),
  DropdownMenuItem(value: '+48',  child: Text('+48 🇵🇱')),
  DropdownMenuItem(value: '+7',   child: Text('+7 🇷🇺')),
  DropdownMenuItem(value: '+86',  child: Text('+86 🇨🇳')),
  DropdownMenuItem(value: '+91',  child: Text('+91 🇮🇳')),
  DropdownMenuItem(value: '+92',  child: Text('+92 🇵🇰')),
  DropdownMenuItem(value: '+880', child: Text('+880 🇧🇩')),
  DropdownMenuItem(value: '+94',  child: Text('+94 🇱🇰')),
  DropdownMenuItem(value: '+81',  child: Text('+81 🇯🇵')),
  DropdownMenuItem(value: '+82',  child: Text('+82 🇰🇷')),
  DropdownMenuItem(value: '+60',  child: Text('+60 🇲🇾')),
  DropdownMenuItem(value: '+65',  child: Text('+65 🇸🇬')),
  DropdownMenuItem(value: '+62',  child: Text('+62 🇮🇩')),
  DropdownMenuItem(value: '+66',  child: Text('+66 🇹🇭')),
  DropdownMenuItem(value: '+63',  child: Text('+63 🇵🇭')),
  DropdownMenuItem(value: '+84',  child: Text('+84 🇻🇳')),
  DropdownMenuItem(value: '+55',  child: Text('+55 🇧🇷')),
  DropdownMenuItem(value: '+52',  child: Text('+52 🇲🇽')),
  DropdownMenuItem(value: '+54',  child: Text('+54 🇦🇷')),
  DropdownMenuItem(value: '+57',  child: Text('+57 🇨🇴')),
  DropdownMenuItem(value: '+61',  child: Text('+61 🇦🇺')),
  DropdownMenuItem(value: '+64',  child: Text('+64 🇳🇿')),
  DropdownMenuItem(value: '+27',  child: Text('+27 🇿🇦')),
  DropdownMenuItem(value: '+234', child: Text('+234 🇳🇬')),
  DropdownMenuItem(value: '+254', child: Text('+254 🇰🇪')),
  DropdownMenuItem(value: '+233', child: Text('+233 🇬🇭')),
];

const List<DropdownMenuItem<String>> _palestineOnlyCodes = [
  DropdownMenuItem(value: '+970', child: Text('+970 🇵🇸')),
  DropdownMenuItem(value: '+972', child: Text('+972 🇮🇱')),
];

const Map<String, String> _allCountriesMap = {
  'ps': 'Palestine 🇵🇸',
  'us': 'United States 🇺🇸',
  'gb': 'United Kingdom 🇬🇧',
  'de': 'Germany 🇩🇪',
  'fr': 'France 🇫🇷',
  'ae': 'United Arab Emirates 🇦🇪',
  'sa': 'Saudi Arabia 🇸🇦',
  'jo': 'Jordan 🇯🇴',
  'eg': 'Egypt 🇪🇬',
  'tr': 'Turkey 🇹🇷',
  'ca': 'Canada 🇨🇦',
  'au': 'Australia 🇦🇺',
  'nl': 'Netherlands 🇳🇱',
  'se': 'Sweden 🇸🇪',
  'no': 'Norway 🇳🇴',
  'dk': 'Denmark 🇩🇰',
  'it': 'Italy 🇮🇹',
  'es': 'Spain 🇪🇸',
  'pl': 'Poland 🇵🇱',
  'br': 'Brazil 🇧🇷',
  'mx': 'Mexico 🇲🇽',
  'in': 'India 🇮🇳',
  'pk': 'Pakistan 🇵🇰',
  'ng': 'Nigeria 🇳🇬',
  'za': 'South Africa 🇿🇦',
  'ma': 'Morocco 🇲🇦',
  'tn': 'Tunisia 🇹🇳',
  'dz': 'Algeria 🇩🇿',
  'iq': 'Iraq 🇮🇶',
  'sy': 'Syria 🇸🇾',
  'lb': 'Lebanon 🇱🇧',
  'kw': 'Kuwait 🇰🇼',
  'qa': 'Qatar 🇶🇦',
  'bh': 'Bahrain 🇧🇭',
  'om': 'Oman 🇴🇲',
  'ly': 'Libya 🇱🇾',
  'sd': 'Sudan 🇸🇩',
  'ye': 'Yemen 🇾🇪',
};

// ─── Step indicator labels ─────────────────────────────────────────────────────

enum _CheckoutTab { customerInfo, delivery, payment }

// ─── Main checkout screen ──────────────────────────────────────────────────────

@RoutePage()
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(checkoutNotifierProvider.notifier).startCheckout());
  }

  /// Maps internal checkout steps to our 3 visual tabs.
  _CheckoutTab _tabFromStep(CheckoutStep step) {
    switch (step) {
      case CheckoutStep.address:
        return _CheckoutTab.customerInfo;
      case CheckoutStep.shipping:
        return _CheckoutTab.delivery;
      case CheckoutStep.review:
      case CheckoutStep.processing:
      case CheckoutStep.done:
      case CheckoutStep.failed:
        return _CheckoutTab.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutNotifierProvider);
    final currentTab = checkoutState != null
        ? _tabFromStep(checkoutState.step)
        : _CheckoutTab.customerInfo;

    Widget body;
    if (checkoutState == null) {
      body = Center(child: CircularProgressIndicator(color: context.colors.primary));
    } else {
      switch (checkoutState.step) {
        case CheckoutStep.address:
          body = _CustomerInfoStep(errorMessage: checkoutState.errorMessage);
          break;
        case CheckoutStep.shipping:
          body = _DeliveryStep(
            options: checkoutState.shippingOptions,
            errorMessage: checkoutState.errorMessage,
          );
          break;
        case CheckoutStep.review:
          body = _PaymentStep(
            checkoutState: checkoutState,
            onSubmit: () async {
              final order = await ref.read(checkoutNotifierProvider.notifier).placeOrder();
              if (order != null && mounted && context.mounted) {
                context.router.replace(OrderConfirmationRoute(orderId: order.id));
              }
            },
          );
          break;
        case CheckoutStep.processing:
          body = Center(child: CircularProgressIndicator(color: context.colors.primary));
          break;
        case CheckoutStep.failed:
          body = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  checkoutState.errorMessage ?? t.checkout.payment_failed,
                  style: TextStyle(color: context.colors.error),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: context.colors.primary),
                  onPressed: () {
                    ref.read(checkoutNotifierProvider.notifier).startCheckout();
                  },
                  child: Text(t.checkout.try_again, style: TextStyle(color: context.colors.textPrimary)),
                ),
              ],
            ),
          );
          break;
        case CheckoutStep.done:
          body = const SizedBox.shrink();
          break;
      }
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        title: Text(t.checkout.checkout, style: TextStyle(color: context.colors.textPrimary)),
        leading: IconButton(
          icon: Icon(Icons.close, color: context.colors.textPrimary),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: Column(
        children: [
          // ─── Step indicator ───
          _StepIndicator(currentTab: currentTab),
          const SizedBox(height: 8),
          // ─── Main content ───
          Expanded(child: body),
        ],
      ),
    );
  }
}

// ─── Step indicator (top bar) ──────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final _CheckoutTab currentTab;
  const _StepIndicator({required this.currentTab});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (tab: _CheckoutTab.customerInfo, label: t.checkout.customer_info_step, icon: Icons.person_outline_rounded),
      (tab: _CheckoutTab.delivery, label: t.checkout.delivery_step, icon: Icons.local_shipping_outlined),
      (tab: _CheckoutTab.payment, label: t.checkout.payment_step, icon: Icons.credit_card_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          // Even indices = step circles, odd indices = connector lines
          if (index.isOdd) {
            final prevStep = steps[index ~/ 2];
            final isCompleted = currentTab.index > prevStep.tab.index;
            return Expanded(
              child: Container(
                height: 2,
                color: isCompleted
                    ? context.colors.primary
                    : context.colors.border.withValues(alpha: 0.4),
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final step = steps[stepIndex];
          final isActive = currentTab == step.tab;
          final isCompleted = currentTab.index > step.tab.index;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? context.colors.primary
                      : isCompleted
                          ? context.colors.primary.withValues(alpha: 0.2)
                          : context.colors.surface,
                  border: Border.all(
                    color: isActive || isCompleted
                        ? context.colors.primary
                        : context.colors.border,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  isCompleted ? Icons.check_rounded : step.icon,
                  size: 18,
                  color: isActive
                      ? Colors.white
                      : isCompleted
                          ? context.colors.primary
                          : context.colors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                step.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? context.colors.primary
                      : isCompleted
                          ? context.colors.textPrimary
                          : context.colors.textMuted,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─── STEP 1: Customer Information ──────────────────────────────────────────────

class _CustomerInfoStep extends ConsumerStatefulWidget {
  final String? errorMessage;
  const _CustomerInfoStep({this.errorMessage});

  @override
  ConsumerState<_CustomerInfoStep> createState() => _CustomerInfoStepState();
}

class _CustomerInfoStepState extends ConsumerState<_CustomerInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _address1Ctrl;
  late TextEditingController _provinceCtrl;
  late TextEditingController _emailCtrl;
  String _countryCode = '+970';
  String _selectedCountryCode = 'ps';
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authNotifierProvider);
    final email = authState.mapOrNull(authenticated: (a) => a.email) ?? '';

    _firstNameCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _address1Ctrl = TextEditingController();
    _provinceCtrl = TextEditingController();
    _emailCtrl = TextEditingController(text: email);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _address1Ctrl.dispose();
    _provinceCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, {Widget? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon,
      labelStyle: TextStyle(color: context.colors.textSecondary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.colors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.colors.error, width: 1.5),
      ),
      filled: true,
      fillColor: context.colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    try {
      await ref.read(checkoutNotifierProvider.notifier).submitAddress(
        ShippingAddress(
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          address1: _address1Ctrl.text.trim(),
          city: _cityCtrl.text.trim(),
          phone: '$_countryCode${_phoneCtrl.text.trim()}',
          countryCode: _selectedCountryCode,
          province: _provinceCtrl.text.trim().isEmpty ? null : _provinceCtrl.text.trim(),
        ),
        _emailCtrl.text.trim(),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine cart product type composition for country selection rules.
    final cart = ref.watch(cartProvider).valueOrNull;
    final hasPhysical = cart?.hasPhysicalItems ?? true;

    // hasDigital = at least one item is digital
    final hasDigital = cart != null && cart.items.any(
      (item) => item.productTypeId == 'ptyp_digital_waslaq',
    );
    // Mixed cart = has both physical and digital items
    final isMixedCart = hasPhysical && hasDigital;

    final countryCodes = hasPhysical ? _palestineOnlyCodes : _allCountryCodes;

    // If switching to Palestine-only and current code is not Palestinian, reset.
    if (hasPhysical && _countryCode != '+970' && _countryCode != '+972') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _countryCode = '+970');
      });
    }
    // If switching to Palestine-only and current country is not 'ps', reset.
    if (hasPhysical && _selectedCountryCode != 'ps') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedCountryCode = 'ps');
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Section title ───
            _SectionHeader(
              icon: Icons.person_outline_rounded,
              title: t.checkout.customer_info_title,
            ),
            const SizedBox(height: 16),

            // ─── Email ───
            TextFormField(
              controller: _emailCtrl,
              decoration: _inputDecoration(
                t.checkout.email,
                prefixIcon: Icon(Icons.email_outlined, color: context.colors.textMuted, size: 20),
              ),
              style: TextStyle(color: context.colors.textPrimary),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v == null || v.isEmpty ? t.common.required : null,
            ),
            const SizedBox(height: 14),

            // ─── First Name / Last Name row ───
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameCtrl,
                    decoration: _inputDecoration(t.checkout.first_name),
                    style: TextStyle(color: context.colors.textPrimary),
                    validator: (v) => v == null || v.isEmpty ? t.common.required : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameCtrl,
                    decoration: _inputDecoration(t.checkout.last_name),
                    style: TextStyle(color: context.colors.textPrimary),
                    validator: (v) => v == null || v.isEmpty ? t.common.required : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ─── Phone with country code prefix ───
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    border: Border.all(color: context.colors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _countryCode,
                      dropdownColor: context.colors.surface,
                      style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
                      icon: Icon(Icons.arrow_drop_down, color: context.colors.textMuted, size: 18),
                      items: countryCodes,
                      onChanged: (v) { if (v != null) setState(() => _countryCode = v); },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _phoneCtrl,
                    decoration: _inputDecoration(
                      t.checkout.phone,
                      prefixIcon: Icon(Icons.phone_outlined, color: context.colors.textMuted, size: 20),
                    ),
                    style: TextStyle(color: context.colors.textPrimary),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.isEmpty ? t.common.required : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ─── Shipping address section ───
            _SectionHeader(
              icon: Icons.location_on_outlined,
              title: t.checkout.shipping_address,
            ),
            const SizedBox(height: 16),

            // ─── Country Selection ───
            DropdownButtonFormField<String>(
              initialValue: _selectedCountryCode,
              decoration: _inputDecoration(
                t.checkout.country,
                prefixIcon: Icon(Icons.flag_outlined, color: context.colors.textMuted, size: 20),
              ),
              dropdownColor: context.colors.surface,
              style: TextStyle(color: context.colors.textPrimary),
              icon: hasPhysical
                  ? const SizedBox.shrink()
                  : Icon(Icons.arrow_drop_down, color: context.colors.textMuted),
              items: (hasPhysical ? {'ps': 'Palestine 🇵🇸'} : _allCountriesMap)
                  .entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: hasPhysical
                  ? null
                  : (v) {
                      if (v != null) {
                        setState(() => _selectedCountryCode = v);
                      }
                    },
            ),

            // ─── Mixed cart warning (physical + digital) ───
            if (isMixedCart) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFBF00).withValues(alpha: 0.4)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Color(0xFFFFBF00), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t.checkout.mixed_cart_warning,
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),

            // ─── City ───
            TextFormField(
              controller: _cityCtrl,
              decoration: _inputDecoration(
                t.checkout.city,
                prefixIcon: Icon(Icons.location_city_outlined, color: context.colors.textMuted, size: 20),
              ),
              style: TextStyle(color: context.colors.textPrimary),
              validator: (v) => v == null || v.isEmpty ? t.common.required : null,
            ),
            const SizedBox(height: 14),

            // ─── Address line 1 ───
            TextFormField(
              controller: _address1Ctrl,
              decoration: _inputDecoration(
                t.checkout.address_line_1,
                prefixIcon: Icon(Icons.home_outlined, color: context.colors.textMuted, size: 20),
              ),
              style: TextStyle(color: context.colors.textPrimary),
              validator: (v) => v == null || v.isEmpty ? t.common.required : null,
            ),
            const SizedBox(height: 14),

            // ─── Province (optional) ───
            TextFormField(
              controller: _provinceCtrl,
              decoration: _inputDecoration(
                t.checkout.province_optional,
                prefixIcon: Icon(Icons.map_outlined, color: context.colors.textMuted, size: 20),
              ),
              style: TextStyle(color: context.colors.textPrimary),
            ),

            // ─── Error message ───
            if (widget.errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: context.colors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.colors.error.withValues(alpha: 0.3)),
                ),
                child: Text(
                  widget.errorMessage!,
                  style: TextStyle(color: context.colors.error, fontSize: 13),
                ),
              ),
            ],

            const SizedBox(height: 28),

            // ─── Continue button ───
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            t.checkout.continue_delivery,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ─── STEP 2: Delivery (Shipping) ───────────────────────────────────────────────

class _DeliveryStep extends ConsumerStatefulWidget {
  final List<ShippingOption> options;
  final String? errorMessage;

  const _DeliveryStep({required this.options, this.errorMessage});

  @override
  ConsumerState<_DeliveryStep> createState() => _DeliveryStepState();
}

class _DeliveryStepState extends ConsumerState<_DeliveryStep> {
  String? _selectedId;
  bool _submitting = false;

  Future<void> _submit() async {
    if (_selectedId == null) return;
    setState(() { _submitting = true; });
    try {
      await ref.read(checkoutNotifierProvider.notifier).selectShipping(_selectedId!);
    } finally {
      if (mounted) setState(() { _submitting = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.local_shipping_outlined,
            title: t.checkout.select_shipping,
          ),
          const SizedBox(height: 16),

          Expanded(
            child: widget.options.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_shipping_outlined, size: 48, color: context.colors.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          t.checkout.no_shipping_options,
                          style: TextStyle(color: context.colors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: widget.options.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final option = widget.options[index];
                      final isSelected = _selectedId == option.id;

                      return GestureDetector(
                        onTap: _submitting
                            ? null
                            : () => setState(() => _selectedId = option.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? context.colors.primary.withValues(alpha: 0.08)
                                : context.colors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? context.colors.primary
                                  : context.colors.border,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                color: isSelected
                                    ? context.colors.primary
                                    : context.colors.textMuted,
                                size: 22,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option.name,
                                      style: TextStyle(
                                        color: context.colors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₪${option.amount}',
                                style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Error display
          if (widget.errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: context.colors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.colors.error.withValues(alpha: 0.3)),
              ),
              child: Text(
                widget.errorMessage!,
                style: TextStyle(color: context.colors.error, fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
          ],

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: (_selectedId == null || _submitting) ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          t.checkout.continue_payment,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ─── STEP 3: Payment (Stripe Card) ─────────────────────────────────────────────

class _PaymentStep extends ConsumerStatefulWidget {
  final CheckoutSession checkoutState;
  final VoidCallback onSubmit;

  const _PaymentStep({required this.checkoutState, required this.onSubmit});

  @override
  ConsumerState<_PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends ConsumerState<_PaymentStep> {
  bool _agreedToTerms = false;
  bool _paying = false;
  String? _payError;

  Future<void> _payWithStripe() async {
    final clientSecret = widget.checkoutState.clientSecret;
    if (clientSecret == null || clientSecret.isEmpty) {
      setState(() => _payError = 'Payment session not ready. Please go back and try again.');
      return;
    }

    setState(() { _paying = true; _payError = null; });

    try {
      final shippingAddr = widget.checkoutState.shippingAddress;
      final countryCode = shippingAddr?.countryCode ?? 'ps';

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'واصلك',
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.dark,
          billingDetails: BillingDetails(
            address: Address(
              country: countryCode.toUpperCase(),
              city: shippingAddr?.city,
              line1: shippingAddr?.address1,
              line2: '',
              postalCode: '',
              state: shippingAddr?.province,
            ),
            name: '${shippingAddr?.firstName ?? ''} ${shippingAddr?.lastName ?? ''}'.trim(),
            phone: shippingAddr?.phone,
          ),
          // Billing address already collected in step 1 — don't ask again.
          billingDetailsCollectionConfiguration:
              const BillingDetailsCollectionConfiguration(
            address: AddressCollectionMode.never,
            name: CollectionMode.never,
            phone: CollectionMode.never,
            email: CollectionMode.never,
            attachDefaultsToPaymentMethod: true,
          ),
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF6C3EE8),
              background: Color(0xFF121212),
              componentBackground: Color(0xFF1E1E1E),
              primaryText: Color(0xFFFFFFFF),
              secondaryText: Color(0xFFB0B0B0),
              componentText: Color(0xFFFFFFFF),
              placeholderText: Color(0xFF808080),
              icon: Color(0xFF6C3EE8),
              componentBorder: Color(0xFF333333),
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // Payment authorized — complete the order
      if (mounted) widget.onSubmit();
    } on StripeException catch (e) {
      if (mounted) {
        final code = e.error.code;
        if (code == FailureCode.Canceled) {
          setState(() { _paying = false; _payError = null; });
        } else {
          setState(() {
            _paying = false;
            _payError = e.error.localizedMessage ?? e.error.message ?? 'Payment failed. Please try again.';
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() { _paying = false; _payError = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cart = cartState.valueOrNull;

    if (cart == null) {
      return Center(child: Text(t.checkout.cart_empty, style: TextStyle(color: context.colors.error)));
    }

    final selectedOption = widget.checkoutState.shippingOptions.firstWhere(
      (o) => o.id == widget.checkoutState.selectedShippingOptionId,
      orElse: () => const ShippingOption(id: '', name: 'Unknown', amount: 0),
    );

    final shippingAddr = widget.checkoutState.shippingAddress;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Order Summary ───
          _SectionHeader(
            icon: Icons.receipt_long_outlined,
            title: t.checkout.order_summary,
          ),
          const SizedBox(height: 12),

          // Items
          Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colors.border),
            ),
            child: Column(
              children: [
                ...cart.items.asMap().entries.map((entry) {
                  final item = entry.value;
                  final isLast = entry.key == cart.items.length - 1;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(
                          children: [
                            // Thumbnail
                            if (item.thumbnail != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.thumbnail!,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: context.colors.border,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.image_outlined, color: context.colors.textMuted, size: 20),
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: context.colors.border,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.image_outlined, color: context.colors.textMuted, size: 20),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      color: context.colors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    t.checkout.qty(count: item.quantity.toString()),
                                    style: TextStyle(color: context.colors.textMuted, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '₪${item.unitPrice * item.quantity}',
                              style: TextStyle(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast) Divider(height: 1, color: context.colors.border),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ─── Shipping info ───
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_shipping_outlined, size: 16, color: context.colors.primary),
                    const SizedBox(width: 8),
                    Text(
                      t.checkout.shipping,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₪${selectedOption.amount}',
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  selectedOption.name,
                  style: TextStyle(color: context.colors.textMuted, fontSize: 12),
                ),
                if (shippingAddr != null) ...[
                  const SizedBox(height: 8),
                  Divider(height: 1, color: context.colors.border),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 14, color: context.colors.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        '${shippingAddr.firstName} ${shippingAddr.lastName}',
                        style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: context.colors.textMuted),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${shippingAddr.address1}, ${shippingAddr.city}',
                          style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ─── Total ───
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.checkout.total,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '₪${cart.total}',
                  style: TextStyle(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ─── Payment error ───
          if (_payError != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: context.colors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.colors.error.withValues(alpha: 0.3)),
              ),
              child: Text(_payError!, style: TextStyle(color: context.colors.error, fontSize: 13)),
            ),
            const SizedBox(height: 12),
          ],

          // ─── Terms checkbox ───
          _TermsCheckbox(
            value: _agreedToTerms,
            onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
            onTermsTap: () => context.router.push(const TermsRoute()),
            onPrivacyTap: () => context.router.push(const PrivacyPolicyRoute()),
          ),
          const SizedBox(height: 20),

          // ─── Pay button ───
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: (_agreedToTerms && !_paying) ? _payWithStripe : null,
              child: _paying
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          '${t.checkout.pay_now} ₪${cart.total}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 8),

          // ─── Secure payment footer ───
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user_outlined, size: 14, color: context.colors.textMuted),
                const SizedBox(width: 4),
                Text(
                  t.checkout.secure_processing,
                  style: TextStyle(color: context.colors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Shared widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: context.colors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

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
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: context.colors.textSecondary, fontSize: 13, height: 1.5),
              children: [
                TextSpan(text: t.checkout.agree_prefix),
                TextSpan(
                  text: t.checkout.terms_link,
                  style: TextStyle(
                    color: context.colors.primaryLight,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTermsTap,
                ),
                TextSpan(text: t.checkout.and_text),
                TextSpan(
                  text: t.checkout.privacy_link,
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
