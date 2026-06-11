// lib/core/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The three choices the user can make.
enum AppThemeMode { dark, light, system }

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  static const _storage = FlutterSecureStorage();
  static const _key = 'waslaq_theme';

  ThemeNotifier() : super(AppThemeMode.system) {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    try {
      final saved = await _storage.read(key: _key);
      state = switch (saved) {
        'light'  => AppThemeMode.light,
        'system' => AppThemeMode.system,
        _        => AppThemeMode.system,
      };
    } catch (_) {}
  }

  Future<void> setMode(AppThemeMode mode) async {
    state = mode;
    try {
      await _storage.write(
        key: _key,
        value: switch (mode) {
          AppThemeMode.light  => 'light',
          AppThemeMode.system => 'system',
          AppThemeMode.dark   => 'dark',
        },
      );
    } catch (_) {}
  }

  /// Converts our enum to Flutter's ThemeMode for MaterialApp.
  ThemeMode get flutterThemeMode => switch (state) {
    AppThemeMode.light  => ThemeMode.light,
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.dark   => ThemeMode.dark,
  };
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>(
  (ref) => ThemeNotifier(),
);
