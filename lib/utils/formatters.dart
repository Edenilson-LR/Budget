import 'package:intl/intl.dart';
import '../models/currency.dart';

String formatCurrency(double amount, String currencyCode, List<Currency> currencies) {
  final currency = currencies.firstWhere(
    (c) => c.code == currencyCode,
    orElse: () => currencies.isNotEmpty ? currencies.first : Currency(
      id: '',
      code: 'USD',
      symbol: '\$',
      name: 'Dólar',
    ),
  );

  final formatter = NumberFormat.currency(
    symbol: currency.symbol,
    decimalDigits: 2,
  );

  return formatter.format(amount);
}

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatDateShort(DateTime date) {
  return DateFormat('MMM dd', 'es').format(date);
}

