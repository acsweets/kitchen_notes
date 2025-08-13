import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String type; // 'recipe' or 'ingredient'

  @HiveField(3)
  bool isDefault;

  Category({
    required this.id,
    required this.name,
    required this.type,
    this.isDefault = false,
  });
}