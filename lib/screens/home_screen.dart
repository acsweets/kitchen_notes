import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/data_provider.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import '../widgets/category_tabs.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('灶边记', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.backgroundSecondary,
        elevation: 0,
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
            color: AppColors.backgroundSecondary,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索菜谱...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
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
                    const Text(
                      '常做菜谱',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.local_fire_department, 
                                               size: 16, color: Colors.orange[700]),
                                          const SizedBox(width: 4),
                                          Text('做过${recipe.cookCount}次'),
                                          const Spacer(),
                                          if (recipe.rating > 0) ...[
                                            Icon(Icons.star, size: 16, color: Colors.amber[700]),
                                            const SizedBox(width: 2),
                                            Text(recipe.rating.toStringAsFixed(1)),
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
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('还没有菜谱，快来添加第一道菜吧！', 
                             style: TextStyle(color: Colors.grey)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
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