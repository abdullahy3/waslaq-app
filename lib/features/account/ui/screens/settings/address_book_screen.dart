import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';
import 'package:waslaq_app/features/account/data/models/address_model.dart';
import 'package:waslaq_app/features/account/providers/account_providers.dart';

@RoutePage()
class AddressBookScreen extends ConsumerStatefulWidget {
  const AddressBookScreen({super.key});

  @override
  ConsumerState<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends ConsumerState<AddressBookScreen> {
  List<AddressModel> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoading = true);
    try {
      final list = await ref.read(accountRepositoryProvider).getAddresses();
      setState(() {
        _addresses = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load addresses: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    try {
      await ref.read(accountRepositoryProvider).deleteAddress(addressId);
      _loadAddresses();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Address deleted successfully'), backgroundColor: context.colors.success),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete address: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  void _showAddressForm([AddressModel? address]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return _AddressFormSheet(
              address: address,
              scrollController: scrollController,
              onSave: (data) async {
                try {
                  if (address == null) {
                    await ref.read(accountRepositoryProvider).addAddress(data);
                  } else {
                    await ref.read(accountRepositoryProvider).updateAddress(address.id, data);
                  }
                  _loadAddresses();
                  if (!mounted) return;
                  Navigator.pop(ctx);
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Failed to save address: $e'), backgroundColor: context.colors.error),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('Address Book', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _addresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off_outlined, size: 64, color: context.colors.textMuted),
                      const SizedBox(height: 16),
                      Text('No addresses found', style: TextStyle(color: context.colors.textSecondary, fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _addresses.length,
                  itemBuilder: (context, idx) {
                    final addr = _addresses[idx];
                    return _AddressCard(
                      address: addr,
                      onEdit: () => _showAddressForm(addr),
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: context.colors.surface,
                            title: const Text('Delete Address'),
                            content: const Text('Are you sure you want to delete this address?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                              FilledButton(
                                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  _deleteAddress(addr.id);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: context.colors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _showAddressForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    address.label?.toUpperCase() ?? 'HOME',
                    style: TextStyle(color: context.colors.primary, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 8),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'DEFAULT',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: onEdit),
                IconButton(icon: Icon(Icons.delete_outline, size: 20, color: Colors.red[400]), onPressed: onDelete),
              ],
            ),
            const SizedBox(height: 8),
            Text(address.fullName ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text('${address.city ?? ''}, ${address.governorate ?? ''}', style: TextStyle(color: context.colors.textSecondary)),
            if (address.street != null && address.street!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(address.street!, style: TextStyle(color: context.colors.textMuted, fontSize: 13)),
            ],
            if (address.landmark != null && address.landmark!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.pin_drop_outlined, size: 16, color: context.colors.primary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      address.landmark!,
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 13, fontStyle: FontStyle.italic),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 16, color: context.colors.textMuted),
                const SizedBox(width: 4),
                Text(address.phone ?? '', style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
                if (address.whatsapp != null && address.whatsapp!.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(address.whatsapp!, style: const TextStyle(color: Colors.green, fontSize: 13)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressFormSheet extends StatefulWidget {
  final AddressModel? address;
  final ScrollController scrollController;
  final Future<void> Function(Map<String, dynamic> data) onSave;

  const _AddressFormSheet({
    this.address,
    required this.scrollController,
    required this.onSave,
  });

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _labelController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _whatsappController;
  late TextEditingController _cityController;
  late TextEditingController _neighbourhoodController;
  late TextEditingController _streetController;
  late TextEditingController _landmarkController;
  late TextEditingController _mapPinUrlController;

  String? _governorate;
  bool _whatsappSameAsPhone = false;
  bool _isDefault = false;
  bool _isSaving = false;

  final List<String> _governorates = [
    'Ramallah', 'Nablus', 'Hebron', 'Jenin', 'Tulkarm', 'Qalqilya', 'Salfit',
    'Jericho & Al-Aghwar', 'Bethlehem', 'Jerusalem',
    'Gaza City', 'North Gaza', 'Deir al-Balah', 'Khan Yunis', 'Rafah'
  ];

  @override
  void initState() {
    super.initState();
    final addr = widget.address;
    _labelController = TextEditingController(text: addr?.label ?? 'Home');
    _fullNameController = TextEditingController(text: addr?.fullName ?? '');
    _phoneController = TextEditingController(text: addr?.phone ?? '');
    _whatsappController = TextEditingController(text: addr?.whatsapp ?? '');
    _cityController = TextEditingController(text: addr?.city ?? '');
    _neighbourhoodController = TextEditingController(text: addr?.neighbourhood ?? '');
    _streetController = TextEditingController(text: addr?.street ?? '');
    _landmarkController = TextEditingController(text: addr?.landmark ?? '');
    _mapPinUrlController = TextEditingController(text: addr?.mapPinUrl ?? '');
    
    _governorate = addr?.governorate;
    _isDefault = addr?.isDefault ?? false;
    
    if (addr != null && addr.phone == addr.whatsapp) {
      _whatsappSameAsPhone = true;
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _cityController.dispose();
    _neighbourhoodController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _mapPinUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: ListView(
          controller: widget.scrollController,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: context.colors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.address == null ? 'Add Address' : 'Edit Address',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildField('Label (e.g. Home, Work)', _labelController, validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            _buildField('Full Name', _fullNameController, validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),

            // Phone
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: context.colors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Phone',
                prefixText: '+970 ',
                prefixStyle: TextStyle(color: context.colors.textSecondary),
                filled: true,
                fillColor: context.colors.surface,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              onChanged: (val) {
                if (_whatsappSameAsPhone) {
                  setState(() => _whatsappController.text = val);
                }
              },
            ),
            const SizedBox(height: 8),

            // Same as Phone Checkbox
            CheckboxListTile(
              title: const Text('WhatsApp is same as phone', style: TextStyle(fontSize: 13)),
              value: _whatsappSameAsPhone,
              activeColor: context.colors.primary,
              onChanged: (val) {
                setState(() {
                  _whatsappSameAsPhone = val ?? false;
                  if (_whatsappSameAsPhone) {
                    _whatsappController.text = _phoneController.text;
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            // WhatsApp
            if (!_whatsappSameAsPhone) ...[
              TextFormField(
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: context.colors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'WhatsApp (Optional)',
                  prefixText: '+970 ',
                  prefixStyle: TextStyle(color: context.colors.textSecondary),
                  filled: true,
                  fillColor: context.colors.surface,
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Governorate
            DropdownButtonFormField<String>(
              value: _governorate,
              style: TextStyle(color: context.colors.textPrimary),
              dropdownColor: context.colors.surface,
              decoration: InputDecoration(
                labelText: 'Governorate',
                filled: true,
                fillColor: context.colors.surface,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
              ),
              items: _governorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              validator: (v) => v == null ? 'Required' : null,
              onChanged: (val) => setState(() => _governorate = val),
            ),
            const SizedBox(height: 12),

            _buildField('City / Town / Camp', _cityController, validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            _buildField('Neighbourhood / Area (Optional)', _neighbourhoodController),
            const SizedBox(height: 12),
            _buildField('Street / Building (Optional)', _streetController),
            const SizedBox(height: 12),

            _buildField(
              'Nearby Landmark (Very Important for delivery)',
              _landmarkController,
              hint: 'e.g. Opposite Al-Wataniya hospital, next to the roundabout',
              validator: (v) => v!.isEmpty ? 'Required to help vendors find you' : null,
            ),
            const SizedBox(height: 12),

            _buildField(
              'Google Maps / WhatsApp Pin Link (Optional)',
              _mapPinUrlController,
              hint: 'https://maps.google.com/...',
            ),
            const SizedBox(height: 12),

            SwitchListTile(
              title: const Text('Set as Default Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              value: _isDefault,
              activeColor: context.colors.primary,
              onChanged: (val) => setState(() => _isDefault = val),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),

            // Info Card at bottom
            Card(
              color: context.colors.primary.withOpacity(0.05),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text('📦 ', style: TextStyle(fontSize: 18)),
                    Expanded(
                      child: Text(
                        'This address will be shared with vendors after purchase for delivery coordination only.',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: _isSaving
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isSaving = true);
                        final data = {
                          'label': _labelController.text.trim(),
                          'full_name': _fullNameController.text.trim(),
                          'phone': _phoneController.text.trim(),
                          'whatsapp': _whatsappController.text.trim(),
                          'governorate': _governorate,
                          'city': _cityController.text.trim(),
                          'neighbourhood': _neighbourhoodController.text.trim(),
                          'street': _streetController.text.trim(),
                          'landmark': _landmarkController.text.trim(),
                          'map_pin_url': _mapPinUrlController.text.trim(),
                          'is_default': _isDefault,
                        };
                        await widget.onSave(data);
                        if (mounted) setState(() => _isSaving = false);
                      }
                    },
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.primary,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save Address', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {String? hint, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: context.colors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: context.colors.textMuted, fontSize: 13),
        filled: true,
        fillColor: context.colors.surface,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
      ),
      validator: validator,
    );
  }
}
