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

  // V2.0 新增字段
  @HiveField(12)
  String? authorId;

  @HiveField(13)
  List<String> images;

  @HiveField(14)
  List<String> tags;

  @HiveField(15)
  int likesCount;

  @HiveField(16)
  int collectionsCount;

  @HiveField(17)
  bool isPublic;

  @HiveField(18)
  String difficulty; // 'easy', 'medium', 'hard'

  @HiveField(19)
  int prepTime; // 准备时间(分钟)

  @HiveField(20)
  int cookTime; // 烹饪时间(分钟)

  @HiveField(21)
  int servings; // 份数

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
    // V2.0 新增字段
    this.authorId,
    this.images = const [],
    this.tags = const [],
    this.likesCount = 0,
    this.collectionsCount = 0,
    this.isPublic = true,
    this.difficulty = 'medium',
    this.prepTime = 30,
    this.cookTime = 30,
    this.servings = 2,
  });
}