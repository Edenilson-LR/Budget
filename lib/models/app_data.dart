import 'account.dart';
import 'category.dart';
import 'currency.dart';
import 'transaction.dart';

class AppData {
  List<Account> accounts;
  List<Category> categories;
  List<Transaction> transactions;
  List<Currency> currencies;

  AppData({
    required this.accounts,
    required this.categories,
    required this.transactions,
    required this.currencies,
  });

  Map<String, dynamic> toJson() {
    return {
      'accounts': accounts.map((a) => a.toJson()).toList(),
      'categories': categories.map((c) => c.toJson()).toList(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'currencies': currencies.map((c) => c.toJson()).toList(),
    };
  }

  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      accounts: (json['accounts'] as List?)
              ?.map((a) => Account.fromJson(a))
              .toList() ??
          [],
      categories: (json['categories'] as List?)
              ?.map((c) => Category.fromJson(c))
              .toList() ??
          [],
      transactions: (json['transactions'] as List?)
              ?.map((t) => Transaction.fromJson(t))
              .toList() ??
          [],
      currencies: (json['currencies'] as List?)
              ?.map((c) => Currency.fromJson(c))
              .toList() ??
          [],
    );
  }

  AppData copyWith({
    List<Account>? accounts,
    List<Category>? categories,
    List<Transaction>? transactions,
    List<Currency>? currencies,
  }) {
    return AppData(
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
      transactions: transactions ?? this.transactions,
      currencies: currencies ?? this.currencies,
    );
  }
}

