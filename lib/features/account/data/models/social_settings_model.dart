class UserSocialSettingsModel {
  final String whoCanMessage;
  final bool readReceipts;
  final String defaultPostVisibility;
  final String contentLanguageFilter;
  final List<String> muteKeywords;
  final bool loginNotifications;
  final bool priceDropAlerts;
  final bool backInStockAlerts;
  final bool vendorNewOrderSound;
  final bool vendorDailySummary;

  const UserSocialSettingsModel({
    this.whoCanMessage = 'everyone',
    this.readReceipts = true,
    this.defaultPostVisibility = 'public',
    this.contentLanguageFilter = 'both',
    this.muteKeywords = const [],
    this.loginNotifications = true,
    this.priceDropAlerts = true,
    this.backInStockAlerts = true,
    this.vendorNewOrderSound = true,
    this.vendorDailySummary = false,
  });

  factory UserSocialSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSocialSettingsModel(
      whoCanMessage: json['whoCanMessage'] as String? ?? 'everyone',
      readReceipts: json['readReceipts'] as bool? ?? true,
      defaultPostVisibility: json['defaultPostVisibility'] as String? ?? 'public',
      contentLanguageFilter: json['contentLanguageFilter'] as String? ?? 'both',
      muteKeywords: (json['muteKeywords'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      loginNotifications: json['loginNotifications'] as bool? ?? true,
      priceDropAlerts: json['priceDropAlerts'] as bool? ?? true,
      backInStockAlerts: json['backInStockAlerts'] as bool? ?? true,
      vendorNewOrderSound: json['vendorNewOrderSound'] as bool? ?? true,
      vendorDailySummary: json['vendorDailySummary'] as bool? ?? false,
    );
  }

  UserSocialSettingsModel copyWith({
    String? whoCanMessage, bool? readReceipts, String? defaultPostVisibility,
    String? contentLanguageFilter, List<String>? muteKeywords,
    bool? loginNotifications, bool? priceDropAlerts, bool? backInStockAlerts,
    bool? vendorNewOrderSound, bool? vendorDailySummary,
  }) {
    return UserSocialSettingsModel(
      whoCanMessage: whoCanMessage ?? this.whoCanMessage,
      readReceipts: readReceipts ?? this.readReceipts,
      defaultPostVisibility: defaultPostVisibility ?? this.defaultPostVisibility,
      contentLanguageFilter: contentLanguageFilter ?? this.contentLanguageFilter,
      muteKeywords: muteKeywords ?? this.muteKeywords,
      loginNotifications: loginNotifications ?? this.loginNotifications,
      priceDropAlerts: priceDropAlerts ?? this.priceDropAlerts,
      backInStockAlerts: backInStockAlerts ?? this.backInStockAlerts,
      vendorNewOrderSound: vendorNewOrderSound ?? this.vendorNewOrderSound,
      vendorDailySummary: vendorDailySummary ?? this.vendorDailySummary,
    );
  }

  Map<String, dynamic> toJson() => {
    'whoCanMessage': whoCanMessage, 'readReceipts': readReceipts,
    'defaultPostVisibility': defaultPostVisibility, 'contentLanguageFilter': contentLanguageFilter,
    'muteKeywords': muteKeywords, 'loginNotifications': loginNotifications,
    'priceDropAlerts': priceDropAlerts, 'backInStockAlerts': backInStockAlerts,
    'vendorNewOrderSound': vendorNewOrderSound, 'vendorDailySummary': vendorDailySummary,
  };
}
