import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/category.dart' as model;
import '../models/ingredient.dart';
import '../models/recipe.dart';

import '../models/cooking_record.dart';
import '../data/default_data.dart';
import '../data/default_recipes.dart';

class DataProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<model.Category> _categories = [];
  List<Ingredient> _ingredients = [];
  List<Recipe> _recipes = [];
  List<CookingRecord> _cookingRecords = [];

  List<model.Category> get categories => _categories;
  List<Ingredient> get ingredients => _ingredients;
  List<Recipe> get recipes => _recipes;
  List<CookingRecord> get cookingRecords => _cookingRecords;

  // 获取菜谱分类
  List<model.Category> get recipeCategories => 
      _categories.where((c) => c.type == 'recipe').toList();

  // 获取食材分类
  List<model.Category> get ingredientCategories => 
      _categories.where((c) => c.type == 'ingredient').toList();

  Future<void> initializeData() async {
    // 初始化数据库
    await _dbHelper.database;
    
    // 初始化默认数据
    await _initializeDefaultData();
    
    // 加载数据
    await _loadData();
  }

  Future<void> _initializeDefaultData() async {
    print('Initializing default data...');
    final categories = await _dbHelper.getCategories();
    final ingredients = await _dbHelper.getIngredients();
    final recipes = await _dbHelper.getRecipes();
    
    print('Category count: ${categories.length}');
    print('Ingredient count: ${ingredients.length}');
    print('Recipe count: ${recipes.length}');
    
    // 如果是首次启动，添加默认数据
    if (categories.isEmpty) {
      print('Adding default categories...');
      final defaultRecipeCategories = DefaultData.getDefaultRecipeCategories();
      final defaultIngredientCategories = DefaultData.getDefaultIngredientCategories();
      
      for (var category in [...defaultRecipeCategories, ...defaultIngredientCategories]) {
        await _dbHelper.insertCategory(category);
      }
      print('Added ${defaultRecipeCategories.length + defaultIngredientCategories.length} categories');
    }

    if (ingredients.isEmpty) {
      print('Adding default ingredients...');
      final defaultIngredients = DefaultData.getDefaultIngredients();
      for (var ingredient in defaultIngredients) {
        await _dbHelper.insertIngredient(ingredient);
      }
      print('Added ${defaultIngredients.length} ingredients');
    }

    if (recipes.isEmpty) {
      print('Adding default recipes...');
      final defaultRecipes = DefaultRecipes.getDefaultRecipes();
      for (var recipe in defaultRecipes) {
        await _dbHelper.insertRecipe(recipe);
      }
      print('Added ${defaultRecipes.length} recipes');
    }
  }
  
  // 强制重新初始化默认数据（用于调试）
  Future<void> resetToDefaults() async {
    // 清空所有表
    final db = await _dbHelper.database;
    await db.delete('cooking_records');
    await db.delete('recipe_steps');
    await db.delete('recipe_ingredients');
    await db.delete('recipes');
    await db.delete('ingredients');
    await db.delete('categories');
    
    await _initializeDefaultData();
    await _loadData();
  }

  Future<void> _loadData() async {
    _categories = await _dbHelper.getCategories();
    _ingredients = await _dbHelper.getIngredients();
    _recipes = await _dbHelper.getRecipes();
    _cookingRecords = await _dbHelper.getCookingRecords();
    notifyListeners();
  }

  // 添加菜谱
  Future<void> addRecipe(Recipe recipe) async {
    await _dbHelper.insertRecipe(recipe);
    _recipes.add(recipe);
    notifyListeners();
  }

  // 更新菜谱
  Future<void> updateRecipe(Recipe recipe) async {
    await _dbHelper.updateRecipe(recipe);
    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _recipes[index] = recipe;
      notifyListeners();
    }
  }

  // 删除菜谱
  Future<void> deleteRecipe(String id) async {
    await _dbHelper.deleteRecipe(id);
    _recipes.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  // 搜索菜谱
  List<Recipe> searchRecipes(String query) {
    if (query.isEmpty) return _recipes;
    
    return _recipes.where((recipe) {
      return recipe.name.toLowerCase().contains(query.toLowerCase()) ||
             recipe.ingredients.any((ing) => 
                 ing.name.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  // 按分类获取菜谱
  List<Recipe> getRecipesByCategory(String categoryId) {
    return _recipes.where((r) => r.categoryId == categoryId).toList();
  }

  // 获取收藏菜谱
  List<Recipe> get favoriteRecipes => 
      _recipes.where((r) => r.isFavorite).toList();

  // 获取常做菜谱（按制作次数排序）
  List<Recipe> get frequentRecipes {
    final sorted = List<Recipe>.from(_recipes);
    sorted.sort((a, b) => b.cookCount.compareTo(a.cookCount));
    return sorted.take(10).toList();
  }

  // 切换收藏状态
  Future<void> toggleFavorite(String recipeId) async {
    final recipe = _recipes.firstWhere((r) => r.id == recipeId);
    recipe.isFavorite = !recipe.isFavorite;
    recipe.updatedAt = DateTime.now();
    await updateRecipe(recipe);
  }

  // 增加制作次数并添加制作记录
  Future<void> incrementCookCount(String recipeId, double rating, String notes) async {
    final recipe = _recipes.firstWhere((r) => r.id == recipeId);
    recipe.cookCount++;
    // 更新平均评分
    if (recipe.rating == 0) {
      recipe.rating = rating;
    } else {
      recipe.rating = (recipe.rating + rating) / 2;
    }
    recipe.updatedAt = DateTime.now();
    await updateRecipe(recipe);
    
    // 添加制作记录
    final cookingRecord = CookingRecord(
      id: const Uuid().v4(),
      recipeId: recipeId,
      recipeName: recipe.name,
      cookingDate: DateTime.now(),
      rating: rating,
      notes: notes,
    );
    await addCookingRecord(cookingRecord);
  }

  // === 分类管理 ===
  
  // 添加分类
  Future<void> addCategory(model.Category category) async {
    await _dbHelper.insertCategory(category);
    _categories.add(category);
    notifyListeners();
  }

  // 更新分类
  Future<void> updateCategory(model.Category category) async {
    await _dbHelper.updateCategory(category);
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
      notifyListeners();
    }
  }

  // 删除分类
  Future<void> deleteCategory(String id) async {
    final category = _categories.firstWhere((c) => c.id == id);
    if (category.isDefault) {
      throw Exception('不能删除默认分类');
    }
    
    // 检查是否有相关数据
    if (category.type == 'recipe') {
      final hasRecipes = _recipes.any((r) => r.categoryId == id);
      if (hasRecipes) {
        throw Exception('该分类下还有菜谱，不能删除');
      }
    } else {
      final hasIngredients = _ingredients.any((i) => i.categoryId == id);
      if (hasIngredients) {
        throw Exception('该分类下还有食材，不能删除');
      }
    }
    
    await _dbHelper.deleteCategory(id);
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // === 食材管理 ===
  
  // 添加食材
  Future<void> addIngredient(Ingredient ingredient) async {
    await _dbHelper.insertIngredient(ingredient);
    _ingredients.add(ingredient);
    notifyListeners();
  }

  // 更新食材
  Future<void> updateIngredient(Ingredient ingredient) async {
    await _dbHelper.updateIngredient(ingredient);
    final index = _ingredients.indexWhere((i) => i.id == ingredient.id);
    if (index != -1) {
      _ingredients[index] = ingredient;
      notifyListeners();
    }
  }

  // 删除食材
  Future<void> deleteIngredient(String id) async {
    await _dbHelper.deleteIngredient(id);
    _ingredients.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  // 按分类获取食材
  List<Ingredient> getIngredientsByCategory(String categoryId) {
    return _ingredients.where((i) => i.categoryId == categoryId).toList();
  }

  // 获取即将过期的食材
  List<Ingredient> get expiringSoonIngredients {
    return _ingredients.where((i) => i.isExpiringSoon || i.isExpired).toList();
  }

  // 搜索食材
  List<Ingredient> searchIngredients(String query) {
    if (query.isEmpty) return _ingredients;
    return _ingredients.where((ingredient) {
      return ingredient.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // === 制作记录管理 ===
  
  // 添加制作记录
  Future<void> addCookingRecord(CookingRecord record) async {
    await _dbHelper.insertCookingRecord(record);
    _cookingRecords.add(record);
    notifyListeners();
  }

  // 更新制作记录
  Future<void> updateCookingRecord(CookingRecord record) async {
    await _dbHelper.updateCookingRecord(record);
    final index = _cookingRecords.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      _cookingRecords[index] = record;
      notifyListeners();
    }
  }

  // 删除制作记录
  Future<void> deleteCookingRecord(String id) async {
    await _dbHelper.deleteCookingRecord(id);
    _cookingRecords.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  // 获取指定日期的制作记录
  List<CookingRecord> getCookingRecordsByDate(DateTime date) {
    return _cookingRecords.where((record) {
      final recordDate = record.cookingDate;
      return recordDate.year == date.year &&
             recordDate.month == date.month &&
             recordDate.day == date.day;
    }).toList();
  }

  // 获取指定月份的制作记录
  List<CookingRecord> getCookingRecordsByMonth(int year, int month) {
    return _cookingRecords.where((record) {
      final recordDate = record.cookingDate;
      return recordDate.year == year && recordDate.month == month;
    }).toList();
  }

  // 获取指定菜谱的制作记录
  List<CookingRecord> getCookingRecordsByRecipe(String recipeId) {
    return _cookingRecords.where((record) => record.recipeId == recipeId)
        .toList()..sort((a, b) => b.cookingDate.compareTo(a.cookingDate));
  }
}