class Currency {
  final String id;
  final String code;
  final String symbol;
  final String name;

  Currency({
    required this.id,
    required this.code,
    required this.symbol,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'symbol': symbol,
      'name': name,
    };
  }

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'] as String,
      code: json['code'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
    );
  }

  Currency copyWith({
    String? id,
    String? code,
    String? symbol,
    String? name,
  }) {
    return Currency(
      id: id ?? this.id,
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
    );
  }
}

