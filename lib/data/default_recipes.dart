import '../models/recipe.dart';
import 'json_data_loader.dart';

class DefaultRecipes {
  static Future<List<Recipe>> getDefaultRecipes() async {
    return await JsonDataLoader.loadRecipes();

  }
}