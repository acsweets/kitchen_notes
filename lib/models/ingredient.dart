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
}