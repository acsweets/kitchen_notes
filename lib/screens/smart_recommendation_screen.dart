import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../services/recommendation_service.dart';
import '../models/recommendation.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class SmartRecommendationScreen extends StatefulWidget {
  const SmartRecommendationScreen({super.key});

  @override
  State<SmartRecommendationScreen> createState() => _SmartRecommendationScreenState();
}

class _SmartRecommendationScreenState extends State<SmartRecommendationScreen> {
  final RecommendationService _recommendationService = RecommendationService();
  List<Recommendation> _recommendations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  void _loadRecommendations() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    
    final ingredientRecommendations = _recommendationService.getIngredientBasedRecommendations(
      'current_user', // 实际应该从用户系统获取
      dataProvider.ingredients,
      dataProvider.recipes,
    );

    final expiryRecommendations = _recommendationService.getExpiryAlertRecommendations(
      'current_user',
      dataProvider.expiringSoonIngredients,
      dataProvider.recipes,
    );

    setState(() {
      _recommendations = [...expiryRecommendations, ...ingredientRecommendations];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      appBar: AppBar(
        title: const Text('智能推荐'),
        backgroundColor: const Color(0xFFE8D5B7),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadRecommendations();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recommendations.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('暂无推荐菜谱', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('添加更多食材后会有智能推荐', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildExpiryAlerts(),
                    const SizedBox(height: 24),
                    _buildIngredientMatches(),
                  ],
                ),
    );
  }

  Widget _buildExpiryAlerts() {
    final expiryRecommendations = _recommendations
        .where((r) => r.type == 'expiry_alert')
        .toList();

    if (expiryRecommendations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.warning, color: Colors.orange[700]),
            const SizedBox(width: 8),
            const Text(
              '即将过期提醒',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...expiryRecommendations.map((recommendation) => 
          _buildRecommendationCard(recommendation, Colors.orange[50]!)),
      ],
    );
  }

  Widget _buildIngredientMatches() {
    final ingredientRecommendations = _recommendations
        .where((r) => r.type == 'ingredient_match')
        .toList();

    if (ingredientRecommendations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.restaurant_menu, color: Colors.green[700]),
            const SizedBox(width: 8),
            const Text(
              '基于现有食材推荐',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...ingredientRecommendations.map((recommendation) => 
          _buildRecommendationCard(recommendation, Colors.green[50]!)),
      ],
    );
  }

  Widget _buildRecommendationCard(Recommendation recommendation, Color backgroundColor) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final recipe = dataProvider.recipes.firstWhere(
          (r) => r.id == recommendation.recipeId,
          orElse: () => throw Exception('Recipe not found'),
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              // 推荐原因
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: _buildRecommendationReason(recommendation),
              ),
              
              // 菜谱卡片
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: RecipeCard(
                  recipe: recipe,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                ),
              ),
              
              // 操作按钮
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Row(
                  children: [
                    if (recommendation.type == 'ingredient_match')
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showShoppingList(recipe),
                          icon: const Icon(Icons.shopping_cart, size: 16),
                          label: const Text('购物清单'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            foregroundColor: Colors.blue[800],
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        },
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('查看详情'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB8860B),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecommendationReason(Recommendation recommendation) {
    if (recommendation.type == 'expiry_alert') {
      final ingredient = recommendation.reason['expiring_ingredient'] as String;
      final days = recommendation.reason['days_until_expiry'] as int?;
      
      return Row(
        children: [
          Icon(Icons.schedule, size: 16, color: Colors.orange[700]),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              days != null && days <= 0 
                  ? '$ingredient已过期，建议尽快使用'
                  : '$ingredient还有${days}天过期',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    } else if (recommendation.type == 'ingredient_match') {
      final matchPercentage = recommendation.reason['match_percentage'] as int;
      final matched = recommendation.reason['matched_ingredients'] as List;
      
      return Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '食材匹配度 $matchPercentage% (已有${matched.length}种食材)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }
    
    return const SizedBox.shrink();
  }

  void _showShoppingList(recipe) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final shoppingList = _recommendationService.generateShoppingList(
      recipe,
      dataProvider.ingredients,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('购物清单'),
        content: shoppingList.isEmpty
            ? const Text('所有食材都已准备好！')
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('还需要购买以下食材：'),
                  const SizedBox(height: 12),
                  ...shoppingList.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_cart, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(item)),
                          ],
                        ),
                      )),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}