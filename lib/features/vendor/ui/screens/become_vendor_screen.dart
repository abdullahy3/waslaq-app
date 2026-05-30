import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../account/data/repositories/account_repository.dart';
import '../../../../i18n/strings.g.dart';

@RoutePage()
class BecomeVendorScreen extends StatefulWidget {
  const BecomeVendorScreen({super.key});

  @override
  State<BecomeVendorScreen> createState() => _BecomeVendorScreenState();
}

class _BecomeVendorScreenState extends State<BecomeVendorScreen> {
  final _storeNameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _selectedZone;
  bool _isSubmitting = false;

  static const _zones = [
    'Gaza City','North Gaza','Deir al-Balah','Khan Younis','Rafah',
    'Ramallah','Nablus','Hebron','Jenin','Tulkarem','Qalqilya',
    'Jericho','Bethlehem','Salfit','Tubas','Jerusalem',
  ];

  List<_BenefitData> get _benefits => [
    _BenefitData(icon: Icons.account_balance_wallet_outlined, title: t.become_vendor.escrow_title, desc: t.become_vendor.escrow_desc),
    _BenefitData(icon: Icons.people_outlined, title: t.become_vendor.community_title, desc: t.become_vendor.community_desc),
    _BenefitData(icon: Icons.local_shipping_outlined, title: t.become_vendor.delivery_title, desc: t.become_vendor.delivery_desc),
    _BenefitData(icon: Icons.bar_chart_outlined, title: t.become_vendor.dashboard_title, desc: t.become_vendor.dashboard_desc),
  ];

  @override
  void dispose() {
    _storeNameCtrl.dispose();
    _descCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final storeName = _storeNameCtrl.text.trim();
    if (storeName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(t.become_vendor.store_name_required),
          backgroundColor: context.colors.error));
      return;
    }
    if (_selectedZone == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(t.become_vendor.select_zone_required),
          backgroundColor: context.colors.error));
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await AccountRepository(MedusaClient.instance).applyAsVendor(
        storeName: storeName,
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        location: _selectedZone,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.become_vendor.application_submitted),
        backgroundColor: context.colors.success,
        duration: const Duration(seconds: 3),
      ));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString().contains('already')
            ? t.become_vendor.already_applied
            : t.become_vendor.submission_failed),
        backgroundColor: context.colors.error,
      ));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.become_vendor.screen_title,
            style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: context.colors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.store, color: Colors.white, size: 36),
                  SizedBox(height: 12),
                  Text(t.become_vendor.header_title,
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
                  SizedBox(height: 8),
                  Text(t.become_vendor.header_subtitle,
                      style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
                ],
              ),
            ),
            SizedBox(height: 28),
            Text(t.become_vendor.why_sell,
                style: TextStyle(color: context.colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ..._benefits.map((b) => _BenefitTile(data: b)),
            SizedBox(height: 28),
            Text(t.become_vendor.store_details,
                style: TextStyle(color: context.colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _FormField(controller: _storeNameCtrl, label: t.become_vendor.store_name_label, hint: t.become_vendor.store_name_hint, icon: Icons.store_outlined),
            SizedBox(height: 14),
            _FormField(controller: _descCtrl, label: t.become_vendor.store_desc_label, hint: t.become_vendor.store_desc_hint, icon: Icons.description_outlined, maxLines: 3),
            SizedBox(height: 14),
            _FormField(controller: _phoneCtrl, label: t.become_vendor.phone_label, hint: t.become_vendor.phone_hint, icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
            SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.colors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedZone,
                  isExpanded: true,
                  dropdownColor: context.colors.surface,
                  hint: Text(t.become_vendor.select_zone_hint, style: TextStyle(color: context.colors.textMuted, fontSize: 14)),
                  icon: Icon(Icons.location_on_outlined, color: context.colors.primary, size: 20),
                  style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
                  items: _zones.map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
                  onChanged: (v) => setState(() => _selectedZone = v),
                ),
              ),
            ),
            SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSubmitting
                    ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(t.become_vendor.submit_application, style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 12),
            Center(child: Text(t.become_vendor.review_time, style: TextStyle(color: context.colors.textMuted, fontSize: 12))),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _BenefitData {
  final IconData icon;
  final String title, desc;
  const _BenefitData({required this.icon, required this.title, required this.desc});
}

class _BenefitTile extends StatelessWidget {
  final _BenefitData data;
  const _BenefitTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: context.colors.border)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: context.colors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(data.icon, color: context.colors.primary, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(height: 3),
                Text(data.desc, style: TextStyle(color: context.colors.textSecondary, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  const _FormField({required this.controller, required this.label, required this.hint, required this.icon, this.maxLines = 1, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label, hintText: hint,
        labelStyle: TextStyle(color: context.colors.textMuted),
        hintStyle: TextStyle(color: context.colors.textMuted),
        prefixIcon: Icon(icon, color: context.colors.primary, size: 20),
        filled: true, fillColor: context.colors.surface,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.colors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.colors.primary, width: 1.5)),
      ),
    );
  }
}
