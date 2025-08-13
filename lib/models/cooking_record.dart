import 'package:hive/hive.dart';

part 'cooking_record.g.dart';

@HiveType(typeId: 4)
class CookingRecord {
  @HiveField(0)
  String id;

  @HiveField(1)
  String recipeId;

  @HiveField(2)
  String recipeName;

  @HiveField(3)
  DateTime cookingDate;

  @HiveField(4)
  double rating;

  @HiveField(5)
  String notes;

  @HiveField(6)
  List<String> images;

  CookingRecord({
    required this.id,
    required this.recipeId,
    required this.recipeName,
    required this.cookingDate,
    required this.rating,
    this.notes = '',
    this.images = const [],
  });
}