import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart' as model;
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/recipe_step.dart';
import '../data/default_data.dart';
import '../data/default_recipes.dart';

class DataProvider extends ChangeNotifier {
  late Box<model.Category> _categoryBox;
  late Box<Ingredient> _ingredientBox;
  late Box<Recipe> _recipeBox;

  List<model.Category> _categories = [];
  List<Ingredient> _ingredients = [];
  List<Recipe> _recipes = [];

  List<model.Category> get categories => _categories;
  List<Ingredient> get ingredients => _ingredients;
  List<Recipe> get recipes => _recipes;

  // 获取菜谱分类
  List<model.Category> get recipeCategories => 
      _categories.where((c) => c.type == 'recipe').toList();

  // 获取食材分类
  List<model.Category> get ingredientCategories => 
      _categories.where((c) => c.type == 'ingredient').toList();

  Future<void> initializeData() async {
    await Hive.initFlutter();
    
    // 注册适配器
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(model.CategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(IngredientAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(RecipeStepAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(RecipeAdapter());
    }

    // 打开数据库
    _categoryBox = await Hive.openBox<model.Category>('categories');
    _ingredientBox = await Hive.openBox<Ingredient>('ingredients');
    _recipeBox = await Hive.openBox<Recipe>('recipes');

    // 初始化默认数据
    await _initializeDefaultData();
    
    // 加载数据
    _loadData();
  }

  Future<void> _initializeDefaultData() async {
    print('Initializing default data...');
    print('Category box length: ${_categoryBox.length}');
    print('Ingredient box length: ${_ingredientBox.length}');
    print('Recipe box length: ${_recipeBox.length}');
    
    // 如果是首次启动，添加默认数据
    if (_categoryBox.isEmpty) {
      print('Adding default categories...');
      final defaultRecipeCategories = DefaultData.getDefaultRecipeCategories();
      final defaultIngredientCategories = DefaultData.getDefaultIngredientCategories();
      
      for (var category in [...defaultRecipeCategories, ...defaultIngredientCategories]) {
        await _categoryBox.put(category.id, category);
      }
      print('Added ${defaultRecipeCategories.length + defaultIngredientCategories.length} categories');
    }

    if (_ingredientBox.isEmpty) {
      print('Adding default ingredients...');
      final defaultIngredients = DefaultData.getDefaultIngredients();
      for (var ingredient in defaultIngredients) {
        await _ingredientBox.put(ingredient.id, ingredient);
      }
      print('Added ${defaultIngredients.length} ingredients');
    }

    if (_recipeBox.isEmpty) {
      print('Adding default recipes...');
      final defaultRecipes = DefaultRecipes.getDefaultRecipes();
      for (var recipe in defaultRecipes) {
        await _recipeBox.put(recipe.id, recipe);
      }
      print('Added ${defaultRecipes.length} recipes');
    }
  }
  
  // 强制重新初始化默认数据（用于调试）
  Future<void> resetToDefaults() async {
    await _categoryBox.clear();
    await _ingredientBox.clear();
    await _recipeBox.clear();
    
    await _initializeDefaultData();
    _loadData();
  }

  void _loadData() {
    _categories = _categoryBox.values.toList();
    _ingredients = _ingredientBox.values.toList();
    _recipes = _recipeBox.values.toList();
    notifyListeners();
  }

  // 添加菜谱
  Future<void> addRecipe(Recipe recipe) async {
    await _recipeBox.put(recipe.id, recipe);
    _recipes.add(recipe);
    notifyListeners();
  }

  // 更新菜谱
  Future<void> updateRecipe(Recipe recipe) async {
    await _recipeBox.put(recipe.id, recipe);
    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _recipes[index] = recipe;
      notifyListeners();
    }
  }

  // 删除菜谱
  Future<void> deleteRecipe(String id) async {
    await _recipeBox.delete(id);
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

  // 增加制作次数
  Future<void> incrementCookCount(String recipeId, double rating) async {
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
  }
}