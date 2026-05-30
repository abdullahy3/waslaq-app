// lib/shared/utils/ils_formatter.dart
// ILS money formatting — NEVER divide or multiply amounts

class ILSFormatter {
  ILSFormatter._();

  /// Format a num amount as ILS currency string
  /// Input: 150 → Output: "₪150.00"
  /// NEVER divide by 100. API returns raw ILS values.
  static String format(num amount) {
    return '₪${amount.toStringAsFixed(2)}';
  }

  /// Format integer amount (no decimal)
  /// Input: 150 → Output: "₪150"
  static String formatInt(int amount) {
    return '₪$amount';
  }

  /// Format with thousands separator
  /// Input: 1500 → Output: "₪1,500.00"
  static String formatWithSeparator(num amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return '₪$intPart.${parts[1]}';
  }
}
