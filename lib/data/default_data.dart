import '../models/category.dart';
import '../models/ingredient.dart';

class DefaultData {
  // 默认菜谱分类
  static List<Category> getDefaultRecipeCategories() {
    return [
      Category(id: 'recipe_home', name: '家常菜', type: 'recipe', isDefault: true),
      Category(id: 'recipe_cold', name: '凉菜', type: 'recipe', isDefault: true),
      Category(id: 'recipe_dessert', name: '甜品', type: 'recipe', isDefault: true),
      Category(id: 'recipe_soup', name: '汤品', type: 'recipe', isDefault: true),
      Category(id: 'recipe_staple', name: '主食', type: 'recipe', isDefault: true),
    ];
  }

  // 默认食材分类
  static List<Category> getDefaultIngredientCategories() {
    return [
      Category(id: 'ingredient_vegetable', name: '蔬菜类', type: 'ingredient', isDefault: true),
      Category(id: 'ingredient_meat', name: '肉类', type: 'ingredient', isDefault: true),
      Category(id: 'ingredient_seafood', name: '海鲜类', type: 'ingredient', isDefault: true),
      Category(id: 'ingredient_seasoning', name: '调味品', type: 'ingredient', isDefault: true),
      Category(id: 'ingredient_staple', name: '主食类', type: 'ingredient', isDefault: true),
    ];
  }

  // 默认食材
  static List<Ingredient> getDefaultIngredients() {
    return [
      // 蔬菜类
      Ingredient(id: 'ing_potato', name: '土豆', categoryId: 'ingredient_vegetable', quantity: 0, unit: '个'),
      Ingredient(id: 'ing_tomato', name: '西红柿', categoryId: 'ingredient_vegetable', quantity: 0, unit: '个'),
      Ingredient(id: 'ing_cucumber', name: '黄瓜', categoryId: 'ingredient_vegetable', quantity: 0, unit: '根'),
      Ingredient(id: 'ing_pepper', name: '青椒', categoryId: 'ingredient_vegetable', quantity: 0, unit: '个'),
      Ingredient(id: 'ing_onion', name: '大葱', categoryId: 'ingredient_vegetable', quantity: 0, unit: '根'),
      Ingredient(id: 'ing_ginger', name: '生姜', categoryId: 'ingredient_vegetable', quantity: 0, unit: '块'),
      Ingredient(id: 'ing_garlic', name: '大蒜', categoryId: 'ingredient_vegetable', quantity: 0, unit: '瓣'),
      
      // 肉类
      Ingredient(id: 'ing_pork', name: '猪肉', categoryId: 'ingredient_meat', quantity: 0, unit: '斤'),
      Ingredient(id: 'ing_chicken', name: '鸡肉', categoryId: 'ingredient_meat', quantity: 0, unit: '斤'),
      Ingredient(id: 'ing_beef', name: '牛肉', categoryId: 'ingredient_meat', quantity: 0, unit: '斤'),
      
      // 调味品
      Ingredient(id: 'ing_salt', name: '盐', categoryId: 'ingredient_seasoning', quantity: 0, unit: '克'),
      Ingredient(id: 'ing_soy_sauce', name: '酱油', categoryId: 'ingredient_seasoning', quantity: 0, unit: '毫升'),
      Ingredient(id: 'ing_vinegar', name: '醋', categoryId: 'ingredient_seasoning', quantity: 0, unit: '毫升'),
      
      // 主食类
      Ingredient(id: 'ing_rice', name: '大米', categoryId: 'ingredient_staple', quantity: 0, unit: '斤'),
      Ingredient(id: 'ing_flour', name: '面粉', categoryId: 'ingredient_staple', quantity: 0, unit: '斤'),
      Ingredient(id: 'ing_egg', name: '鸡蛋', categoryId: 'ingredient_staple', quantity: 0, unit: '个'),
    ];
  }
}