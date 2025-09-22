import 'ingredient.dart';
import 'recipe_step.dart';

class Recipe {
  String id;
  String name;
  String categoryId;
  String? coverImage;
  List<Ingredient> ingredients;
  List<RecipeStep> steps;
  int cookCount;
  double rating;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite;
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'cover_image': coverImage,
      'cook_count': cookCount,
      'rating': rating,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'is_favorite': isFavorite ? 1 : 0,
      'notes': notes,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map, List<Ingredient> ingredients, List<RecipeStep> steps) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      categoryId: map['category_id'],
      coverImage: map['cover_image'],
      ingredients: ingredients,
      steps: steps,
      cookCount: map['cook_count'],
      rating: map['rating'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
      isFavorite: map['is_favorite'] == 1,
      notes: map['notes'] ?? '',
    );
  }
}