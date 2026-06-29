// lib/core/providers/currency_provider.dart
// Display-only currency selection (ILS / USD). Mirrors the storefront:
//  - "IP once, then the dropdown wins": first launch detects country via the
//    backend GET /store/currency (PS → ILS, else → USD) and persists it; after
//    that the saved user choice is the source of truth and IP never overrides.
//  - All money stays ILS in storage/checkout — USD is a fixed-rate display.
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:waslaq_app/core/config/app_config.dart';
import 'package:waslaq_app/shared/utils/ils_formatter.dart';

enum CurrencyCode { ils, usd }

class CurrencyState {
  final CurrencyCode currency;
  final bool loaded;
  const CurrencyState({this.currency = CurrencyCode.ils, this.loaded = false});

  CurrencyState copyWith({CurrencyCode? currency, bool? loaded}) => CurrencyState(
        currency: currency ?? this.currency,
        loaded: loaded ?? this.loaded,
      );
}

class CurrencyNotifier extends StateNotifier<CurrencyState> {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: false,
      resetOnError: true,
    ),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  static const _key = 'waslaq_currency';

  CurrencyNotifier() : super(const CurrencyState()) {
    _init();
  }

  Future<void> _init() async {
    // 1. A saved user choice always wins.
    String? saved;
    try {
      saved = await _storage.read(key: _key);
    } catch (_) {}
    if (saved == 'ILS') return _apply(CurrencyCode.ils);
    if (saved == 'USD') return _apply(CurrencyCode.usd);

    // 2. First launch → detect by IP via the backend (cached server-side 24h).
    CurrencyCode detected = CurrencyCode.ils;
    try {
      final res = await Dio().get(
        '${AppConfig.apiBase}/store/currency',
        options: Options(
          headers: {'x-publishable-api-key': AppConfig.publishableKey},
          sendTimeout: const Duration(seconds: 6),
          receiveTimeout: const Duration(seconds: 6),
        ),
      );
      final data = res.data;
      final cur = (data is Map) ? data['currency'] : null;
      detected = cur == 'USD' ? CurrencyCode.usd : CurrencyCode.ils;
    } catch (_) {
      detected = CurrencyCode.ils; // safe default on any failure
    }

    // Persist the detected default so the IP lookup only ever happens once.
    try {
      await _storage.write(
        key: _key,
        value: detected == CurrencyCode.usd ? 'USD' : 'ILS',
      );
    } catch (_) {}
    _apply(detected);
  }

  Future<void> setCurrency(CurrencyCode c) async {
    _apply(c);
    try {
      await _storage.write(
        key: _key,
        value: c == CurrencyCode.usd ? 'USD' : 'ILS',
      );
    } catch (_) {}
  }

  void _apply(CurrencyCode c) {
    // Sync the global formatter so every ILSFormatter.format() call reflects it.
    ILSFormatter.currency = c == CurrencyCode.usd ? 'USD' : 'ILS';
    state = state.copyWith(currency: c, loaded: true);
  }
}

final currencyProvider =
    StateNotifierProvider<CurrencyNotifier, CurrencyState>(
  (ref) => CurrencyNotifier(),
);
