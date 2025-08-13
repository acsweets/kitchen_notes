import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../models/cooking_record.dart';
import '../models/recommendation.dart';
import 'package:uuid/uuid.dart';

class RecommendationService {
  static const double MIN_MATCH_SCORE = 0.3;

  /// 基于现有食材推荐菜谱
  List<Recommendation> getIngredientBasedRecommendations(
    String userId,
    List<Ingredient> availableIngredients,
    List<Recipe> allRecipes,
  ) {
    final recommendations = <Recommendation>[];

    for (var recipe in allRecipes) {
      final matchResult = _calculateIngredientMatch(recipe, availableIngredients);
      
      if (matchResult['score'] >= MIN_MATCH_SCORE) {
        recommendations.add(Recommendation(
          id: const Uuid().v4(),
          userId: userId,
          recipeId: recipe.id,
          type: 'ingredient_match',
          score: matchResult['score'],
          reason: {
            'matched_ingredients': matchResult['matched'],
            'missing_ingredients': matchResult['missing'],
            'match_percentage': (matchResult['score'] * 100).round(),
          },
          createdAt: DateTime.now(),
        ));
      }
    }

    recommendations.sort((a, b) => b.score.compareTo(a.score));
    return recommendations.take(10).toList();
  }

  /// 即将过期食材推荐
  List<Recommendation> getExpiryAlertRecommendations(
    String userId,
    List<Ingredient> expiringSoonIngredients,
    List<Recipe> allRecipes,
  ) {
    final recommendations = <Recommendation>[];

    for (var ingredient in expiringSoonIngredients) {
      final suitableRecipes = allRecipes.where((recipe) =>
        recipe.ingredients.any((recipeIngredient) =>
          recipeIngredient.name.toLowerCase() == ingredient.name.toLowerCase()
        )
      ).toList();

      for (var recipe in suitableRecipes.take(3)) {
        recommendations.add(Recommendation(
          id: const Uuid().v4(),
          userId: userId,
          recipeId: recipe.id,
          type: 'expiry_alert',
          score: _calculateExpiryUrgency(ingredient),
          reason: {
            'expiring_ingredient': ingredient.name,
            'days_until_expiry': ingredient.daysUntilExpiry,
            'message': '${ingredient.name}即将过期，快来制作这道菜吧！',
          },
          createdAt: DateTime.now(),
        ));
      }
    }

    return recommendations;
  }

  /// 计算食材匹配度
  Map<String, dynamic> _calculateIngredientMatch(
    Recipe recipe,
    List<Ingredient> availableIngredients,
  ) {
    final recipeIngredients = recipe.ingredients;
    final availableNames = availableIngredients
        .map((i) => i.name.toLowerCase())
        .toSet();

    final matched = <String>[];
    final missing = <String>[];

    for (var ingredient in recipeIngredients) {
      final ingredientName = ingredient.name.toLowerCase();
      if (availableNames.contains(ingredientName)) {
        matched.add(ingredient.name);
      } else {
        missing.add(ingredient.name);
      }
    }

    final score = recipeIngredients.isEmpty ? 0.0 : matched.length / recipeIngredients.length;

    return {
      'score': score,
      'matched': matched,
      'missing': missing,
    };
  }

  /// 计算过期紧急程度
  double _calculateExpiryUrgency(Ingredient ingredient) {
    final days = ingredient.daysUntilExpiry ?? 999;
    
    if (days < 0) return 1.0;
    if (days == 0) return 0.9;
    if (days == 1) return 0.8;
    if (days <= 3) return 0.7;
    
    return 0.5;
  }

  /// 生成购物清单
  List<String> generateShoppingList(
    Recipe recipe,
    List<Ingredient> availableIngredients,
  ) {
    final availableNames = availableIngredients
        .map((i) => i.name.toLowerCase())
        .toSet();

    final shoppingList = <String>[];

    for (var ingredient in recipe.ingredients) {
      if (!availableNames.contains(ingredient.name.toLowerCase())) {
        shoppingList.add('${ingredient.name} ${ingredient.quantity} ${ingredient.unit}');
      }
    }

    return shoppingList;
  }
}