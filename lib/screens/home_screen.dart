import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';

import 'add_recipe_screen.dart';
import 'recipe_detail_screen.dart';
import 'favorite_recipes_screen.dart';
import '../services/api_service.dart';
import '../network/models/category_models.dart';
import '../network/models/recipe_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;

  List<CategoryResponse> _categories = [];
  List<RecipeSummary> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final categories = await ApiService.getCategories();
      final recipes = await ApiService.getRecipes();
      if (mounted) {
        setState(() {
          _categories = categories;
          _recipes = recipes.content;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载数据失败: $e')),
        );
      }
    }
  }

  Future<void> _loadRecipesByCategory(int? categoryId) async {
    setState(() => _isLoading = true);
    try {
      final recipes = categoryId != null
          ? await ApiService.getRecipesByCategory(categoryId)
          : await ApiService.getRecipes();
      if (mounted) {
        setState(() {
          _recipes = recipes.content;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载菜谱失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      appBar: AppBar(
        title: const Text('灶边记', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFE8D5B7),
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
            color: const Color(0xFFE8D5B7),
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
                // TODO: 实现搜索功能
              },
            ),
          ),
          
          // 分类标签
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('全部'),
                      selected: _selectedCategoryId == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryId = null;
                        });
                        _loadRecipesByCategory(null);
                      },
                    ),
                  );
                }
                final category = _categories[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(category.icon),
                        const SizedBox(width: 4),
                        Text(category.name),
                      ],
                    ),
                    selected: _selectedCategoryId == category.id,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryId = selected ? category.id : null;
                      });
                      _loadRecipesByCategory(_selectedCategoryId);
                    },
                  ),
                );
              },
            ),
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _recipes.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('还没有菜谱，快来添加第一道菜吧！', 
                                 style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = _recipes[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () async {
                                try {
                                  final detail = await ApiService.getRecipeDetail(recipe.id);
                                  if (mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RecipeDetailScreen(
                                          recipe: null,
                                          recipeDetail: detail,
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('加载菜谱详情失败: $e')),
                                    );
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            recipe.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.favorite, size: 16, color: Colors.red),
                                            const SizedBox(width: 4),
                                            Text('${recipe.likesCount}'),
                                            const SizedBox(width: 12),
                                            Icon(Icons.bookmark, size: 16, color: Colors.blue),
                                            const SizedBox(width: 4),
                                            Text('${recipe.collectionsCount}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      recipe.description,
                                      style: TextStyle(color: Colors.grey[600]),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Chip(
                                          label: Text(recipe.difficulty),
                                          backgroundColor: Colors.orange[100],
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text('${recipe.prepTime + recipe.cookTime}分钟'),
                                        const SizedBox(width: 12),
                                        Icon(Icons.people, size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text('${recipe.servings}人份'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
        backgroundColor: const Color(0xFFB8860B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}