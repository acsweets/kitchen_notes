import 'package:hive/hive.dart';

part 'ingredient.g.dart';

@HiveType(typeId: 1)
class Ingredient {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String categoryId;

  @HiveField(3)
  double quantity;

  @HiveField(4)
  String unit;

  @HiveField(5)
  DateTime? expiryDate;

  Ingredient({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.quantity,
    required this.unit,
    this.expiryDate,
  });

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