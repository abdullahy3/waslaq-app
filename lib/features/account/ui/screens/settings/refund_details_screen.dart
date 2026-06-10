import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';
import 'package:waslaq_app/features/account/data/models/refund_details_model.dart';
import 'package:waslaq_app/features/account/providers/account_providers.dart';

@RoutePage()
class RefundDetailsScreen extends ConsumerStatefulWidget {
  const RefundDetailsScreen({super.key});

  @override
  ConsumerState<RefundDetailsScreen> createState() => _RefundDetailsScreenState();
}

class _RefundDetailsScreenState extends ConsumerState<RefundDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _ibanController;
  late TextEditingController _phoneController;

  String? _bankName;
  String _preferredMethod = 'bank_transfer';
  bool _isLoading = true;
  bool _isSaving = false;

  final List<String> _banks = [
    'Bank of Palestine', 'Arab Bank', 'Cairo Amman Bank', 'Palestine Islamic Bank',
    'Al-Quds Bank', 'Jordan Ahli Bank', 'BLOM Bank', 'PayPal', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _ibanController = TextEditingController();
    _phoneController = TextEditingController();
    _loadRefundDetails();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _ibanController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadRefundDetails() async {
    try {
      final map = await ref.read(accountRepositoryProvider).getRefundDetails();
      if (map != null) {
        final details = RefundDetailsModel.fromJson(map);
        setState(() {
          _fullNameController.text = details.fullName ?? '';
          _ibanController.text = details.iban ?? '';
          _phoneController.text = details.phone ?? '';
          _bankName = details.bankName;
          _preferredMethod = details.preferredMethod ?? 'bank_transfer';
        });
      }
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load refund details: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  Future<void> _saveRefundDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await ref.read(accountRepositoryProvider).updateRefundDetails(
        fullName: _fullNameController.text.trim(),
        bankName: _bankName,
        iban: _ibanController.text.trim(),
        phone: _phoneController.text.trim(),
        preferredMethod: _preferredMethod,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Refund details saved successfully!'), backgroundColor: context.colors.success),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save refund details: $e'), backgroundColor: context.colors.error),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('Refund Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Amber Info Banner
                  Card(
                    color: Colors.amber.withOpacity(0.1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.amber.withOpacity(0.5)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'If a dispute is resolved in your favor or an order is cancelled, WaslaQ will send your refund to the details below. Without this, refunds may be delayed.',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text('Account Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),

                  _buildField('Full Name on Account (as it appears on bank)', _fullNameController),
                  const SizedBox(height: 16),

                  // Bank Dropdown
                  DropdownButtonFormField<String>(
                    value: _bankName,
                    style: TextStyle(color: context.colors.textPrimary),
                    dropdownColor: context.colors.surface,
                    decoration: InputDecoration(
                      labelText: 'Bank Name',
                      filled: true,
                      fillColor: context.colors.surface,
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
                    ),
                    items: _banks.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                    onChanged: (val) => setState(() => _bankName = val),
                  ),
                  const SizedBox(height: 16),

                  _buildField('IBAN / Account Number', _ibanController),
                  const SizedBox(height: 16),

                  _buildField(
                    'Phone for Mobile Transfer',
                    _phoneController,
                    hint: 'For CliQ, PalPay, or Jawwal Pay transfers',
                  ),
                  const SizedBox(height: 24),

                  const Text('Preferred Refund Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),

                  Card(
                    color: context.colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: context.colors.border),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Bank Transfer (IBAN)'),
                          value: 'bank_transfer',
                          groupValue: _preferredMethod,
                          activeColor: context.colors.primary,
                          onChanged: (val) => setState(() => _preferredMethod = val!),
                        ),
                        Divider(height: 1, color: context.colors.border),
                        RadioListTile<String>(
                          title: const Text('Mobile Wallet (CliQ / PalPay)'),
                          value: 'mobile_wallet',
                          groupValue: _preferredMethod,
                          activeColor: context.colors.primary,
                          onChanged: (val) => setState(() => _preferredMethod = val!),
                        ),
                        Divider(height: 1, color: context.colors.border),
                        RadioListTile<String>(
                          title: const Text('Cash credit on next order'),
                          value: 'cash_on_next',
                          groupValue: _preferredMethod,
                          activeColor: context.colors.primary,
                          onChanged: (val) => setState(() => _preferredMethod = val!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  FilledButton(
                    onPressed: _isSaving ? null : _saveRefundDetails,
                    style: FilledButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save Refund Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {String? hint}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: context.colors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: context.colors.textMuted, fontSize: 12),
        filled: true,
        fillColor: context.colors.surface,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
      ),
    );
  }
}
