import 'package:hive/hive.dart';
import 'ingredient.dart';
import 'recipe_step.dart';

part 'recipe.g.dart';

@HiveType(typeId: 3)
class Recipe {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String categoryId;

  @HiveField(3)
  String? coverImage;

  @HiveField(4)
  List<Ingredient> ingredients;

  @HiveField(5)
  List<RecipeStep> steps;

  @HiveField(6)
  int cookCount;

  @HiveField(7)
  double rating;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  @HiveField(10)
  bool isFavorite;

  @HiveField(11)
  String notes;

  Recipe({
    required this.id,
    required this.name,
    required this.categoryId,
    this.coverImage,
    this.ingredients = const [],
    this.steps = const [],
    this.cookCount = 0,
    this.rating = 0.0,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.notes = '',
  });
}