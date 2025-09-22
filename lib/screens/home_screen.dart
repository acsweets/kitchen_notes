import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/data_provider.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import '../widgets/category_tabs.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_buttons.dart';
import 'add_recipe_screen.dart';
import 'recipe_detail_screen.dart';
import 'favorite_recipes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategoryId = '';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('灶边记', style: Theme.of(context).textTheme.displaySmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteRecipesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索框
          Container(
            padding: const EdgeInsets.all(16),
            child: SearchTextField(
              controller: _searchController,
              hintText: '搜索菜谱...',
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onClear: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
          ),
          
          // 分类标签
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              return CategoryTabs(
                categories: dataProvider.recipeCategories,
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: (categoryId) {
                  setState(() {
                    _selectedCategoryId = categoryId;
                  });
                },
              );
            },
          ),
          
          // 常做菜谱模块
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              final frequentRecipes = dataProvider.frequentRecipes
                  .where((r) => r.cookCount > 0)
                  .take(3)
                  .toList();
              
              if (frequentRecipes.isEmpty) return const SizedBox.shrink();
              
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '常做菜谱',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: frequentRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = frequentRecipes[index];
                          return Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: 12),
                            child: Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipeDetailScreen(recipe: recipe),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.name,
                                        style: Theme.of(context).textTheme.headlineMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.local_fire_department, 
                                               size: 16, color: AppColors.warning),
                                          const SizedBox(width: 4),
                                          Text('做过${recipe.cookCount}次',
                                               style: Theme.of(context).textTheme.bodySmall),
                                          const Spacer(),
                                          if (recipe.rating > 0) ...[
                                            Icon(Icons.star, size: 16, color: AppColors.warning),
                                            const SizedBox(width: 2),
                                            Text(recipe.rating.toStringAsFixed(1),
                                                 style: Theme.of(context).textTheme.bodySmall),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // 菜谱列表
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                List<Recipe> recipes = _getFilteredRecipes(dataProvider);
                
                if (recipes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.restaurant_menu, size: 64, color: AppColors.textTertiary),
                        const SizedBox(height: 16),
                        Text('还没有菜谱，快来添加第一道菜吧！', 
                             style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
        },
        icon: Icons.add,
        tooltip: '添加菜谱',
      ),
    );
  }

  List<Recipe> _getFilteredRecipes(DataProvider dataProvider) {
    List<Recipe> recipes = dataProvider.recipes;
    
    // 按搜索关键词过滤
    if (_searchQuery.isNotEmpty) {
      recipes = dataProvider.searchRecipes(_searchQuery);
    }
    
    // 按分类过滤
    if (_selectedCategoryId.isNotEmpty) {
      recipes = recipes.where((r) => r.categoryId == _selectedCategoryId).toList();
    }
    
    return recipes;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}