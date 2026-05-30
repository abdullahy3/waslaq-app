// lib/core/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../i18n/strings.g.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  static const _storage = FlutterSecureStorage();
  static const _key = 'waslaq_locale';

  LocaleNotifier() : super(_deviceDefault()) {
    _loadSaved();
  }

  static Locale _deviceDefault() {
    final lang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return lang == 'en' ? const Locale('en') : const Locale('ar');
  }

  Future<void> _loadSaved() async {
    try {
      final saved = await _storage.read(key: _key);
      if (saved == 'en') {
        state = const Locale('en');
        LocaleSettings.setLocaleRaw('en');
      } else if (saved == 'ar') {
        state = const Locale('ar');
        LocaleSettings.setLocaleRaw('ar');
      } else {
        // Use device default
        final lang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
        LocaleSettings.setLocaleRaw(lang == 'en' ? 'en' : 'ar');
      }
    } catch (_) {}
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    // Update slang so t.xxx translations switch immediately
    LocaleSettings.setLocaleRaw(locale.languageCode);
    try {
      await _storage.write(key: _key, value: locale.languageCode);
    } catch (_) {}
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);
