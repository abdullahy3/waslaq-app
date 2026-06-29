// lib/shared/utils/ils_formatter.dart
// Money formatting. Amounts are ALWAYS stored/charged in raw ILS — NEVER divide
// or multiply for storage. USD is a DISPLAY-ONLY conversion at a fixed rate
// (1 USD = 3.7 ILS). `currency` is set by CurrencyNotifier
// (lib/core/providers/currency_provider.dart) and read here so every existing
// ILSFormatter.format() call reflects the user's choice without changing call sites.

class ILSFormatter {
  ILSFormatter._();

  /// Fixed display rate. 1 USD = 3.7 ILS. Edit here to change it.
  static const double ilsPerUsd = 3.7;
  static const double _usdRate = 1 / ilsPerUsd; // ILS→USD multiplier

  /// Active display currency: 'ILS' or 'USD'. Updated by CurrencyNotifier.
  static String currency = 'ILS';

  static bool get _usd => currency == 'USD';

  /// Format a num amount as currency string.
  /// ILS: 150 → "₪150.00".  USD: 150 → "$40.54" (150 / 3.7).
  /// NEVER divide by 100 — API returns raw ILS values.
  static String format(num amount) {
    if (_usd) return '\$${(amount * _usdRate).toStringAsFixed(2)}';
    return '₪${amount.toStringAsFixed(2)}';
  }

  /// Format integer amount (no decimal in ILS).
  static String formatInt(int amount) {
    if (_usd) return '\$${(amount * _usdRate).toStringAsFixed(2)}';
    return '₪$amount';
  }

  /// Format with thousands separator.
  /// ILS: 1500 → "₪1,500.00".  USD: 1500 → "$405.41".
  static String formatWithSeparator(num amount) {
    final symbol = _usd ? '\$' : '₪';
    final value = _usd ? amount * _usdRate : amount;
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return '$symbol$intPart.${parts[1]}';
  }
}
