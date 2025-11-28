enum AccountType {
  cash,
  bank,
  card,
  crypto,
}

class Account {
  final String id;
  final String name;
  final AccountType type;
  final String currency;
  final double initialBalance;
  double currentBalance;
  final String color;

  Account({
    required this.id,
    required this.name,
    required this.type,
    required this.currency,
    required this.initialBalance,
    required this.currentBalance,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'currency': currency,
      'initialBalance': initialBalance,
      'currentBalance': currentBalance,
      'color': color,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      name: json['name'] as String,
      type: AccountType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AccountType.cash,
      ),
      currency: json['currency'] as String,
      initialBalance: (json['initialBalance'] as num).toDouble(),
      currentBalance: (json['currentBalance'] as num).toDouble(),
      color: json['color'] as String,
    );
  }

  Account copyWith({
    String? id,
    String? name,
    AccountType? type,
    String? currency,
    double? initialBalance,
    double? currentBalance,
    String? color,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      initialBalance: initialBalance ?? this.initialBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      color: color ?? this.color,
    );
  }
}

