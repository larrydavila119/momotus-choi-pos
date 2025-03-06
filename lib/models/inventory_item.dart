class InventoryItem {
  final String id;
  final String name;
  final double price;
  final String barCode;
  final int quantity;
  final String category;
  final String currency;

  InventoryItem(
      {required this.id,
      required this.name,
      required this.price,
      required this.barCode,
      required this.quantity,
      required this.category,
      required this.currency});

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        barCode: json['bar_code'],
        quantity: json['quantity'],
        category: json['category'],
        currency: json['currency']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'barCode': barCode,
      'quantity': quantity,
      'category': category,
    };
  }
}

class MonthlyItem extends InventoryItem {
  final List<dynamic> monthsToPay;

  MonthlyItem({
    required this.monthsToPay,
    required super.id,
    required super.name,
    required super.price,
    required super.barCode,
    required super.quantity,
    required super.category,
    required super.currency,
  });

  factory MonthlyItem.fromJson(Map<String, dynamic> json) {
    return MonthlyItem(
      monthsToPay: List<Map<String, dynamic>>.from(json['months_to_pay'] ?? []),
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      barCode: json['bar_code'],
      quantity: json['quantity'],
      category: json['category'],
      currency: json['currency'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['months_to_pay'] = monthsToPay;
    return json;
  }

  MonthlyItem copyWith({
    List<Map<String, dynamic>>? monthsToPay,
    String? id,
    String? name,
    double? price,
    String? barCode,
    int? quantity,
    String? category,
    String? currency,
  }) {
    return MonthlyItem(
      monthsToPay: monthsToPay ?? this.monthsToPay,
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      barCode: barCode ?? this.barCode,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      currency: currency ?? this.currency,
    );
  }

  @override
  String toString() {
    return 'MonthlyItem(id: $id, name: $name, price: $price, barCode: $barCode, quantity: $quantity, category: $category, currency: $currency, monthsToPay: $monthsToPay)';
  }
}