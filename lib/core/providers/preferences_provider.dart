import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AppPreferences {
  final double textScale;
  final String arabicFont;
  final bool boldText;
  final bool reduceAnimations;
  final bool hapticFeedback;
  final bool biometricLock;
  final bool purchaseConfirmation;
  final String contentLanguage;
  final List<String> muteKeywords;
  final String postDefaultVisibility;
  final int autoRefreshMinutes;

  const AppPreferences({
    this.textScale = 1.0,
    this.arabicFont = 'default',
    this.boldText = false,
    this.reduceAnimations = false,
    this.hapticFeedback = true,
    this.biometricLock = false,
    this.purchaseConfirmation = false,
    this.contentLanguage = 'both',
    this.muteKeywords = const [],
    this.postDefaultVisibility = 'public',
    this.autoRefreshMinutes = 5,
  });

  AppPreferences copyWith({
    double? textScale, String? arabicFont, bool? boldText, bool? reduceAnimations,
    bool? hapticFeedback, bool? biometricLock, bool? purchaseConfirmation,
    String? contentLanguage, List<String>? muteKeywords,
    String? postDefaultVisibility, int? autoRefreshMinutes,
  }) {
    return AppPreferences(
      textScale: textScale ?? this.textScale,
      arabicFont: arabicFont ?? this.arabicFont,
      boldText: boldText ?? this.boldText,
      reduceAnimations: reduceAnimations ?? this.reduceAnimations,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      biometricLock: biometricLock ?? this.biometricLock,
      purchaseConfirmation: purchaseConfirmation ?? this.purchaseConfirmation,
      contentLanguage: contentLanguage ?? this.contentLanguage,
      muteKeywords: muteKeywords ?? this.muteKeywords,
      postDefaultVisibility: postDefaultVisibility ?? this.postDefaultVisibility,
      autoRefreshMinutes: autoRefreshMinutes ?? this.autoRefreshMinutes,
    );
  }
}

class PreferencesNotifier extends StateNotifier<AppPreferences> {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: false,
      resetOnError: true,
    ),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  static const _key = 'waslaq_preferences';

  PreferencesNotifier([AppPreferences? initial]) : super(initial ?? const AppPreferences()) {
    if (initial == null) {
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw != null) {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        state = AppPreferences(
          textScale: (map['textScale'] as num?)?.toDouble() ?? 1.0,
          arabicFont: map['arabicFont'] as String? ?? 'default',
          boldText: map['boldText'] as bool? ?? false,
          reduceAnimations: map['reduceAnimations'] as bool? ?? false,
          hapticFeedback: map['hapticFeedback'] as bool? ?? true,
          biometricLock: map['biometricLock'] as bool? ?? false,
          purchaseConfirmation: map['purchaseConfirmation'] as bool? ?? false,
          contentLanguage: map['contentLanguage'] as String? ?? 'both',
          muteKeywords: (map['muteKeywords'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
          postDefaultVisibility: map['postDefaultVisibility'] as String? ?? 'public',
          autoRefreshMinutes: map['autoRefreshMinutes'] as int? ?? 5,
        );
      }
    } catch (_) {}
  }

  Future<void> update(AppPreferences prefs) async {
    state = prefs;
    try {
      await _storage.write(key: _key, value: jsonEncode({
        'textScale': prefs.textScale, 'arabicFont': prefs.arabicFont,
        'boldText': prefs.boldText, 'reduceAnimations': prefs.reduceAnimations,
        'hapticFeedback': prefs.hapticFeedback, 'biometricLock': prefs.biometricLock,
        'purchaseConfirmation': prefs.purchaseConfirmation,
        'contentLanguage': prefs.contentLanguage, 'muteKeywords': prefs.muteKeywords,
        'postDefaultVisibility': prefs.postDefaultVisibility,
        'autoRefreshMinutes': prefs.autoRefreshMinutes,
      }));
    } catch (_) {}
  }
}

final preferencesProvider = StateNotifierProvider<PreferencesNotifier, AppPreferences>(
  (ref) => PreferencesNotifier(),
);
