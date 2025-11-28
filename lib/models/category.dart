import 'transaction.dart';

class Category {
  final String id;
  final String name;
  final TransactionType type;
  final String icon;
  final double budgetLimit;
  final String color;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.budgetLimit,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'icon': icon,
      'budgetLimit': budgetLimit,
      'color': color,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      icon: json['icon'] as String,
      budgetLimit: (json['budgetLimit'] as num).toDouble(),
      color: json['color'] as String,
    );
  }

  Category copyWith({
    String? id,
    String? name,
    TransactionType? type,
    String? icon,
    double? budgetLimit,
    String? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      budgetLimit: budgetLimit ?? this.budgetLimit,
      color: color ?? this.color,
    );
  }
}

