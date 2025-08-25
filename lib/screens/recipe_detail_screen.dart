import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';

import '../network/models/recipe_models.dart' as network;

import '../providers/data_provider.dart';
import 'add_recipe_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe? recipe;
  final network.RecipeDetailResponse? recipeDetail;

  const RecipeDetailScreen({super.key, this.recipe, this.recipeDetail});

  network.RecipeDetailResponse get _recipe {
    if (recipeDetail != null) return recipeDetail!;
    if (recipe != null) return _convertToNetworkModel(recipe!);
    throw Exception('Both recipe and recipeDetail are null');
  }

  network.RecipeDetailResponse _convertToNetworkModel(Recipe localRecipe) {
    return network.RecipeDetailResponse(
      id: int.tryParse(localRecipe.id) ?? 0,
      title: localRecipe.name,
      description: localRecipe.notes,
      categoryId: int.tryParse(localRecipe.categoryId),
      images: localRecipe.coverImage != null ? [localRecipe.coverImage!] : [],
      tags: [],
      likesCount: 0,
      collectionsCount: 0,
      difficulty: '中等',
      prepTime: 15,
      cookTime: 30,
      servings: 2,
      author: network.AuthorInfo(id: 0, username: '本地用户'),
      createdAt: localRecipe.createdAt,
      isPublic: false,
      ingredients: localRecipe.ingredients.map((ing) => network.RecipeIngredient(
        id: 0,
        name: ing.name,
        amount: ing.quantity.toString(),
        unit: ing.unit,
      )).toList(),
      steps: localRecipe.steps.map((step) => network.RecipeStep(
        id: 0,
        stepNumber: step.order,
        description: step.description,
        images: [],
      )).toList(),
      updatedAt: localRecipe.updatedAt,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      appBar: AppBar(
        title: Text(_recipe.title),
        backgroundColor: const Color(0xFFE8D5B7),
        actions: [
          if (recipe != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRecipeScreen(recipe: recipe),
                  ),
                );
              },
            ),
          if (recipe != null)
            Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                final currentRecipe = dataProvider.recipes.firstWhere((r) => r.id == recipe!.id);
                return IconButton(
                  icon: Icon(
                    currentRecipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: currentRecipe.isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    dataProvider.toggleFavorite(recipe!.id);
                  },
                );
              },
            ),
        ],
      ),
      body: ListView(
        children: [
          // 封面图片
          if (_recipe.images.isNotEmpty)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_recipe.images.first),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              height: 200,
              color: const Color(0xFFE8D5B7),
              child: const Icon(Icons.restaurant, size: 80, color: Colors.grey),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 菜谱信息
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _recipe.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.favorite, size: 20, color: Colors.red),
                              const SizedBox(width: 4),
                              Text('${_recipe.likesCount}'),
                              const SizedBox(width: 16),
                              Icon(Icons.bookmark, size: 20, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text('${_recipe.collectionsCount}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (recipe != null)
                      ElevatedButton.icon(
                        onPressed: () {
                          _showCookingDialog(context);
                        },
                        icon: const Icon(Icons.restaurant_menu),
                        label: const Text('我做了这道菜'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB8860B),
                          foregroundColor: Colors.white,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                // 配料部分
                const Text(
                  '配料',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                if (_recipe.ingredients.isEmpty)
                  const Text('暂无配料信息', style: TextStyle(color: Colors.grey))
                else
                  ..._recipe.ingredients.map((ingredient) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFB8860B),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${ingredient.name} ${ingredient.amount} ${ingredient.unit}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      )),

                const SizedBox(height: 24),

                // 制作步骤
                const Text(
                  '制作步骤',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                if (_recipe.steps.isEmpty)
                  const Text('暂无制作步骤', style: TextStyle(color: Colors.grey))
                else
                  ..._recipe.steps.map((step) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFFB8860B),
                              child: Text(
                                '${step.stepNumber}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                step.description,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 24),

                // 备注部分
                if (_recipe.description.isNotEmpty) ...[
                  const Text(
                    '备注',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8DC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE8D5B7)),
                    ),
                    child: Text(
                      _recipe.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],

                // 制作心得部分 - 仅本地菜谱显示
                if (recipe != null)
                  Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      final cookingRecords = dataProvider.getCookingRecordsByRecipe(recipe!.id);
                    if (cookingRecords.isEmpty) return const SizedBox.shrink();
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const Text(
                          '制作心得',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ...cookingRecords.take(3).map((record) => Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${record.cookingDate.month}-${record.cookingDate.day}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < record.rating ? Icons.star : Icons.star_border,
                                            size: 16,
                                            color: Colors.amber,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  if (record.notes.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      record.notes,
                                      style: const TextStyle(fontSize: 14, height: 1.4),
                                    ),
                                  ],
                                ],
                              ),
                            )),
                      ],
                    );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCookingDialog(BuildContext context) {
    double rating = 0;
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('制作完成'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('给这次制作打个分吧！'),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          rating = index + 1.0;
                        });
                      },
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: '制作心得（可选）',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (rating > 0 && recipe != null) {
                Provider.of<DataProvider>(context, listen: false)
                    .incrementCookCount(recipe!.id, rating, noteController.text);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('制作记录已保存！')),
              );
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}