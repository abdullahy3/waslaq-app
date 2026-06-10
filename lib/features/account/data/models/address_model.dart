class AddressModel {
  final String id;
  final String? label, fullName, phone, whatsapp, governorate, city, neighbourhood, street, landmark, mapPinUrl;
  final bool isDefault;
  final DateTime createdAt;

  const AddressModel({
    required this.id,
    this.label,
    this.fullName,
    this.phone,
    this.whatsapp,
    this.governorate,
    this.city,
    this.neighbourhood,
    this.street,
    this.landmark,
    this.mapPinUrl,
    this.isDefault = false,
    required this.createdAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      label: json['label'] as String?,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      whatsapp: json['whatsapp'] as String?,
      governorate: json['governorate'] as String?,
      city: json['city'] as String?,
      neighbourhood: json['neighbourhood'] as String?,
      street: json['street'] as String?,
      landmark: json['landmark'] as String?,
      mapPinUrl: json['map_pin_url'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
    );
  }
}
