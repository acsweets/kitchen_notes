import '../models/category.dart';
import '../models/ingredient.dart';
import 'json_data_loader.dart';

class DefaultData {
  // 默认菜谱分类
  static Future<List<Category>> getDefaultRecipeCategories() async {
    final categories = await JsonDataLoader.loadCategories();
    return categories.where((c) => c.type == 'recipe').toList();
  }

  // 默认食材分类
  static Future<List<Category>> getDefaultIngredientCategories() async {
    final categories = await JsonDataLoader.loadCategories();
    return categories.where((c) => c.type == 'ingredient').toList();
  }

  // 默认食材
  static Future<List<Ingredient>> getDefaultIngredients() async {
    return await JsonDataLoader.loadIngredients();
  }
}