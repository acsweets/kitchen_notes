import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../models/category.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/recipe_step.dart';

class JsonDataLoader {
  static const _uuid = Uuid();

  // 加载分类数据
  static Future<List<Category>> loadCategories() async {
    final String jsonString = await rootBundle.loadString('assets/data/categories.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    
    List<Category> categories = [];
    
    // 加载菜谱分类
    for (var item in data['recipe_categories']) {
      categories.add(Category.fromJson(item));
    }
    
    // 加载食材分类
    for (var item in data['ingredient_categories']) {
      categories.add(Category.fromJson(item));
    }
    
    return categories;
  }

  // 加载食材数据
  static Future<List<Ingredient>> loadIngredients() async {
    final String jsonString = await rootBundle.loadString('assets/data/ingredients.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    
    List<Ingredient> ingredients = [];
    
    // 加载各类食材
    for (var category in ['vegetables', 'meat', 'seasonings', 'staples']) {
      if (data[category] != null) {
        for (var item in data[category]) {
          ingredients.add(Ingredient.fromJson(item));
        }
      }
    }
    
    return ingredients;
  }

  // 加载菜谱数据
  static Future<List<Recipe>> loadRecipes() async {
    final String jsonString = await rootBundle.loadString('assets/data/recipes.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final now = DateTime.now();
    
    List<Recipe> recipes = [];
    
    for (var recipeData in data['recipes']) {
      // 处理食材
      List<Ingredient> ingredients = [];
      if (recipeData['ingredients'] != null) {
        for (var ingredientData in recipeData['ingredients']) {
          ingredients.add(Ingredient(
            id: _uuid.v4(),
            name: ingredientData['name'],
            categoryId: ingredientData['categoryId'],
            quantity: ingredientData['quantity']?.toDouble() ?? 0.0,
            unit: ingredientData['unit'] ?? '',
          ));
        }
      }

      // 处理步骤
      List<RecipeStep> steps = [];
      if (recipeData['steps'] != null) {
        for (var stepData in recipeData['steps']) {
          steps.add(RecipeStep(
            order: stepData['order'],
            description: stepData['description'],
          ));
        }
      }

      recipes.add(Recipe(
        id: _uuid.v4(),
        name: recipeData['name'],
        categoryId: recipeData['categoryId'],
        ingredients: ingredients,
        steps: steps,
        createdAt: now,
        updatedAt: now,
        notes: recipeData['notes'] ?? '',
      ));
    }
    
    return recipes;
  }
}