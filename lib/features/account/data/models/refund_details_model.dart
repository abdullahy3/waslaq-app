class RefundDetailsModel {
  final String? fullName, bankName, iban, phone, preferredMethod;

  const RefundDetailsModel({this.fullName, this.bankName, this.iban, this.phone, this.preferredMethod = 'bank_transfer'});

  factory RefundDetailsModel.fromJson(Map<String, dynamic> json) {
    return RefundDetailsModel(
      fullName: json['full_name'] as String?,
      bankName: json['bank_name'] as String?,
      iban: json['iban'] as String?,
      phone: json['phone'] as String?,
      preferredMethod: json['preferred_method'] as String? ?? 'bank_transfer',
    );
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName, 'bankName': bankName, 'iban': iban,
    'phone': phone, 'preferredMethod': preferredMethod,
  };
}
