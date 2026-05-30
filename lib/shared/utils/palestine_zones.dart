// lib/shared/utils/palestine_zones.dart
// Delivery zones matching the backend delivery_zone field in vendor schema
// (store/vendors/me/update route accepts delivery_zone: z.string().optional())

class PalestineZones {
  PalestineZones._();

  static const List<String> westBankCities = [
    'Nablus', 'Ramallah', 'Hebron', 'Jenin', 'Tulkarm',
    'Qalqilya', 'Bethlehem', 'Jericho', 'Salfit', 'Tubas',
    'Rawabi', 'Al-Bireh',
  ];

  static const List<String> gazaCities = [
    'Gaza City', 'Khan Yunis', 'Rafah', 'Deir al-Balah',
    'Jabalia', 'Beit Lahiya', 'Beit Hanoun',
  ];

  static List<String> get allCities => [
    ...westBankCities,
    ...gazaCities,
  ];

  static bool isWestBank(String city) => westBankCities.contains(city);
  static bool isGaza(String city) => gazaCities.contains(city);
}
