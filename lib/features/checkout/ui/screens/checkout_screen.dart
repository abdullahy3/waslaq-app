import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../i18n/strings.g.dart';

import '../../../../core/auth/auth_notifier.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../data/models/checkout_model.dart';
import '../../providers/checkout_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutNotifierProvider);

    Widget body;
    if (checkoutState == null) {
      body = Center(child: CircularProgressIndicator(color: context.colors.primary));
    } else {
      switch (checkoutState.step) {
        case CheckoutStep.address:
          body = _AddressForm(
            onSubmit: (address, email) {
              ref.read(checkoutNotifierProvider.notifier).submitAddress(address, email);
            },
          );
          break;
        case CheckoutStep.shipping:
          body = _ShippingList(
            options: checkoutState.shippingOptions,
            onSubmit: (optionId) {
              ref.read(checkoutNotifierProvider.notifier).selectShipping(optionId);
            },
          );
          break;
        case CheckoutStep.review:
          body = _OrderReview(
            checkoutState: checkoutState,
            onSubmit: () async {
              final order = await ref.read(checkoutNotifierProvider.notifier).placeOrder();
              if (order != null && mounted) {
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
                SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: context.colors.primary),
                  onPressed: () {
                    ref.read(checkoutNotifierProvider.notifier).startCheckout();
                  },
                  child: Text(t.checkout.try_again, style: TextStyle(color: context.colors.textPrimary)),
                )
              ],
            ),
          );
          break;
        case CheckoutStep.done:
          body = SizedBox.shrink();
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
      body: body,
    );
  }
}

class _AddressForm extends ConsumerStatefulWidget {
  final void Function(ShippingAddress address, String email) onSubmit;
  const _AddressForm({required this.onSubmit});

  @override
  ConsumerState<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<_AddressForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _address1Ctrl;
  late TextEditingController _provinceCtrl;
  late TextEditingController _emailCtrl;

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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: context.colors.textSecondary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.colors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailCtrl,
              decoration: _inputDecoration(t.checkout.email),
              style: TextStyle(color: context.colors.textPrimary),
              validator: (v) => v == null || v.isEmpty ? t.common.required : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _firstNameCtrl,
              decoration: _inputDecoration(t.checkout.first_name),
              style: TextStyle(color: context.colors.textPrimary),
              validator: (v) => v == null || v.isEmpty ? t.common.required : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _lastNameCtrl,
              decoration: _inputDecoration(t.checkout.last_name),
              style: TextStyle(color: context.colors.textPrimary),
              validator: (v) => v == null || v.isEmpty ? t.common.required : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _phoneCtrl,
              decoration: _inputDecoration(t.checkout.phone),
              style: TextStyle(color: context.colors.textPrimary),
              validator: (v) => v == null || v.isEmpty ? t.common.required : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _cityCtrl,
              decoration: _inputDecoration(t.checkout.city),
              style: TextStyle(color: context.colors.textPrimary),
              validator: (v) => v == null || v.isEmpty ? t.common.required : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _address1Ctrl,
              decoration: _inputDecoration(t.checkout.address_line_1),
              style: TextStyle(color: context.colors.textPrimary),
              validator: (v) => v == null || v.isEmpty ? t.common.required : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _provinceCtrl,
              decoration: _inputDecoration(t.checkout.province_optional),
              style: TextStyle(color: context.colors.textPrimary),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: context.colors.primary),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onSubmit(
                      ShippingAddress(
                        firstName: _firstNameCtrl.text.trim(),
                        lastName: _lastNameCtrl.text.trim(),
                        address1: _address1Ctrl.text.trim(),
                        city: _cityCtrl.text.trim(),
                        phone: _phoneCtrl.text.trim(),
                        province: _provinceCtrl.text.trim().isEmpty ? null : _provinceCtrl.text.trim(),
                      ),
                      _emailCtrl.text.trim(),
                    );
                  }
                },
                child: Text(t.checkout.continue_shipping, style: TextStyle(color: context.colors.textPrimary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShippingList extends StatefulWidget {
  final List<ShippingOption> options;
  final void Function(String optionId) onSubmit;

  const _ShippingList({required this.options, required this.onSubmit});

  @override
  State<_ShippingList> createState() => _ShippingListState();
}

class _ShippingListState extends State<_ShippingList> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.checkout.select_shipping,
            style: TextStyle(color: context.colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final option = widget.options[index];
                return RadioListTile<String>(
                  title: Text(option.name, style: TextStyle(color: context.colors.textPrimary)),
                  subtitle: Text('₪${option.amount}', style: TextStyle(color: context.colors.textSecondary)),
                  activeColor: context.colors.primary,
                  value: option.id,
                  groupValue: _selectedId,
                  onChanged: (val) => setState(() => _selectedId = val),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: context.colors.primary),
              onPressed: _selectedId == null
                  ? null
                  : () {
                      widget.onSubmit(_selectedId!);
                    },
              child: Text(t.checkout.continue_review, style: TextStyle(color: context.colors.textPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderReview extends ConsumerStatefulWidget {
  final CheckoutSession checkoutState;
  final VoidCallback onSubmit;

  const _OrderReview({required this.checkoutState, required this.onSubmit});

  @override
  ConsumerState<_OrderReview> createState() => _OrderReviewState();
}

class _OrderReviewState extends ConsumerState<_OrderReview> {
  bool _agreedToTerms = false;
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.checkout.review_order,
            style: TextStyle(color: context.colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  title: Text(item.title, style: TextStyle(color: context.colors.textPrimary)),
                  subtitle: Text(t.checkout.qty(count: item.quantity.toString()), style: TextStyle(color: context.colors.textSecondary)),
                  trailing: Text('₪${item.unitPrice * item.quantity}', style: TextStyle(color: context.colors.textPrimary)),
                );
              },
            ),
          ),
          Divider(color: context.colors.border),
          ListTile(
            title: Text(t.checkout.shipping, style: TextStyle(color: context.colors.textPrimary)),
            subtitle: Text(selectedOption.name, style: TextStyle(color: context.colors.textSecondary)),
            trailing: Text('₪${selectedOption.amount}', style: TextStyle(color: context.colors.textPrimary)),
          ),
          ListTile(
            title: Text(t.checkout.total, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
            trailing: Text(
              '₪${cart.total}',
              style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          SizedBox(height: 16),
          // Terms Agreement Checkbox
          _TermsCheckbox(
            value: _agreedToTerms,
            onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
            onTermsTap: () => context.router.push(const TermsRoute()),
            onPrivacyTap: () => context.router.push(const PrivacyPolicyRoute()),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: context.colors.primary),
              onPressed: _agreedToTerms ? widget.onSubmit : null,
              child: Text(t.checkout.place_order, style: TextStyle(color: context.colors.textPrimary)),
            ),
          ),
        ],
      ),
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
