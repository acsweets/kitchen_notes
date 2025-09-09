class Ingredient {
  String id;
  String name;
  String categoryId;
  double quantity;
  String unit;
  DateTime? expiryDate;

  Ingredient({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.quantity,
    required this.unit,
    this.expiryDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'quantity': quantity,
      'unit': unit,
      'expiry_date': expiryDate?.millisecondsSinceEpoch,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'],
      name: map['name'],
      categoryId: map['category_id'],
      quantity: map['quantity'],
      unit: map['unit'],
      expiryDate: map['expiry_date'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['expiry_date'])
          : null,
    );
  }

  // 计算距离过期还有多少天
  int? get daysUntilExpiry {
    if (expiryDate == null) return null;
    final now = DateTime.now();
    final difference = expiryDate!.difference(DateTime(now.year, now.month, now.day));
    return difference.inDays;
  }

  // 是否即将过期（3天内）
  bool get isExpiringSoon {
    final days = daysUntilExpiry;
    return days != null && days <= 3 && days >= 0;
  }

  // 是否已过期
  bool get isExpired {
    final days = daysUntilExpiry;
    return days != null && days < 0;
  }
}