import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';
import 'package:waslaq_app/core/api/medusa_client.dart';
import 'package:waslaq_app/features/account/data/models/social_settings_model.dart';
import 'package:waslaq_app/features/account/providers/account_providers.dart';

@RoutePage()
class VendorSettingsScreen extends ConsumerStatefulWidget {
  const VendorSettingsScreen({super.key});

  @override
  ConsumerState<VendorSettingsScreen> createState() => _VendorSettingsScreenState();
}

class _VendorSettingsScreenState extends ConsumerState<VendorSettingsScreen> {
  bool _vacationMode = false;
  bool _isLoadingVacation = true;
  DateTime? _vacationStartDate;

  UserSocialSettingsModel? _socialSettings;
  bool _isLoadingSettings = true;

  // Delivery zones state
  final List<String> _westBankCities = [
    'Ramallah', 'Nablus', 'Hebron', 'Jenin', 'Tulkarm',
    'Qalqilya', 'Salfit', 'Jericho', 'Bethlehem', 'Jerusalem'
  ];

  final List<String> _gazaCities = [
    'Gaza City', 'North Gaza', 'Deir al-Balah', 'Khan Yunis', 'Rafah'
  ];

  final Set<String> _selectedCities = {};
  bool _isSavingDelivery = false;

  @override
  void initState() {
    super.initState();
    _loadVacationModeAndSettings();
    _loadDeliveryZones();
  }

  Future<void> _loadVacationModeAndSettings() async {
    try {
      final repo = ref.read(accountRepositoryProvider);
      final map = await repo.getSocialSettings();
      setState(() {
        _socialSettings = UserSocialSettingsModel.fromJson(map);
        _isLoadingSettings = false;
        // Vacation mode usually comes from vendor details. Let's start as false.
        _vacationMode = false;
        _isLoadingVacation = false;
      });
    } catch (_) {
      setState(() {
        _isLoadingSettings = false;
        _isLoadingVacation = false;
      });
    }
  }

  Future<void> _loadDeliveryZones() async {
    try {
      final res = await MedusaClient.instance.get('/store/vendors/me/delivery-zones');
      final cities = res.data['deliveryCities'] as List<dynamic>? ?? [];
      setState(() {
        _selectedCities.addAll(cities.map((e) => e.toString()));
      });
    } catch (_) {}
  }

  Future<void> _toggleVacationMode(bool val) async {
    setState(() {
      _vacationMode = val;
      _vacationStartDate = val ? DateTime.now() : null;
    });
    try {
      await ref.read(accountRepositoryProvider).setVacationMode(val);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(val ? 'Vacation Mode Enabled!' : 'Vacation Mode Disabled!'),
          backgroundColor: context.colors.success,
        ),
      );
    } catch (e) {
      setState(() {
        _vacationMode = !val;
        _vacationStartDate = !val ? DateTime.now() : null;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to set vacation mode: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  Future<void> _saveDeliveryZones() async {
    setState(() => _isSavingDelivery = true);
    try {
      await MedusaClient.instance.patch(
        '/store/vendors/me/delivery-zones',
        data: {
          'deliveryZone': _selectedCities.length == (_westBankCities.length + _gazaCities.length) ? 'palestine' : 'custom',
          'deliveryCities': _selectedCities.toList(),
        },
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Delivery zones saved successfully!'), backgroundColor: context.colors.success),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save delivery zones: $e'), backgroundColor: context.colors.error),
      );
    } finally {
      if (mounted) setState(() => _isSavingDelivery = false);
    }
  }

  Future<void> _updateSocialSettings(UserSocialSettingsModel newSettings) async {
    try {
      setState(() => _socialSettings = newSettings);
      await ref.read(accountRepositoryProvider).updateSocialSettings(newSettings.toJson());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  void _toggleAllCities(bool val) {
    setState(() {
      if (val) {
        _selectedCities.addAll(_westBankCities);
        _selectedCities.addAll(_gazaCities);
      } else {
        _selectedCities.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allCount = _westBankCities.length + _gazaCities.length;
    final isEverywhere = _selectedCities.length == allCount;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('Vendor Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: _isLoadingSettings || _isLoadingVacation
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ─── STORE STATUS (VACATION MODE) ───
                _buildSectionHeader('Store Status'),
                Card(
                  color: context.colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: context.colors.border),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        activeColor: context.colors.primary,
                        title: const Text('Vacation Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: const Text('When ON: store shows vacation banner. Buyers cannot place new orders.',
                            style: TextStyle(fontSize: 11)),
                        value: _vacationMode,
                        onChanged: _toggleVacationMode,
                      ),
                      if (_vacationMode && _vacationStartDate != null) ...[
                        Divider(height: 1, color: context.colors.border),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 16, color: context.colors.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Activated on: ${_vacationStartDate!.toLocal().toString().split(' ')[0]}',
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ─── DELIVERY ZONES ───
                _buildSectionHeader('Delivery Zones'),
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
                        const Text('Where do you deliver?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeColor: context.colors.primary,
                          title: const Text('Deliver Everywhere (Palestine)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          value: isEverywhere,
                          onChanged: _toggleAllCities,
                        ),
                        const SizedBox(height: 12),
                        
                        // West Bank Group
                        const Text('West Bank Cities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 8),
                        _buildCityCheckboxes(_westBankCities),
                        const SizedBox(height: 16),

                        // Gaza Group
                        const Text('Gaza Cities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 8),
                        _buildCityCheckboxes(_gazaCities),
                        const SizedBox(height: 24),

                        FilledButton(
                          onPressed: _isSavingDelivery ? null : _saveDeliveryZones,
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _isSavingDelivery
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Save Delivery Zones', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ─── NOTIFICATIONS (VENDOR) ───
                if (_socialSettings != null) ...[
                  _buildSectionHeader('Notifications'),
                  Card(
                    color: context.colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: context.colors.border),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          activeColor: context.colors.primary,
                          title: const Text('New Order Alert Sound', style: TextStyle(fontSize: 14)),
                          value: _socialSettings!.vendorNewOrderSound,
                          onChanged: (val) {
                            _updateSocialSettings(_socialSettings!.copyWith(vendorNewOrderSound: val));
                          },
                        ),
                        Divider(height: 1, color: context.colors.border),
                        SwitchListTile(
                          activeColor: context.colors.primary,
                          title: const Text('Daily Sales Summary', style: TextStyle(fontSize: 14)),
                          value: _socialSettings!.vendorDailySummary,
                          onChanged: (val) {
                            _updateSocialSettings(_socialSettings!.copyWith(vendorDailySummary: val));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: context.colors.textMuted, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildCityCheckboxes(List<String> cities) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4.0,
      ),
      itemCount: cities.length,
      itemBuilder: (context, idx) {
        final city = cities[idx];
        final isChecked = _selectedCities.contains(city);
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(city, style: const TextStyle(fontSize: 13)),
          value: isChecked,
          activeColor: context.colors.primary,
          onChanged: (val) {
            setState(() {
              if (val == true) {
                _selectedCities.add(city);
              } else {
                _selectedCities.remove(city);
              }
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      },
    );
  }
}
