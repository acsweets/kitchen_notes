import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/data_provider.dart';
import 'add_recipe_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: const Color(0xFFE8D5B7),
        actions: [
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
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              final currentRecipe = dataProvider.recipes.firstWhere((r) => r.id == recipe.id);
              return IconButton(
                icon: Icon(
                  currentRecipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: currentRecipe.isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  dataProvider.toggleFavorite(recipe.id);
                },
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // 封面图片
          if (recipe.coverImage != null)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(recipe.coverImage!),
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
                            recipe.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (recipe.cookCount > 0) ...[
                                Icon(Icons.local_fire_department, 
                                     size: 20, color: Colors.orange[700]),
                                const SizedBox(width: 4),
                                Text('做过${recipe.cookCount}次'),
                                const SizedBox(width: 16),
                              ],
                              if (recipe.rating > 0) ...[
                                Icon(Icons.star, size: 20, color: Colors.amber[700]),
                                const SizedBox(width: 4),
                                Text(recipe.rating.toStringAsFixed(1)),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
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
                
                if (recipe.ingredients.isEmpty)
                  const Text('暂无配料信息', style: TextStyle(color: Colors.grey))
                else
                  ...recipe.ingredients.map((ingredient) => Padding(
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
                                '${ingredient.name} ${ingredient.quantity} ${ingredient.unit}',
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

                if (recipe.steps.isEmpty)
                  const Text('暂无制作步骤', style: TextStyle(color: Colors.grey))
                else
                  ...recipe.steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
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
                                '${index + 1}',
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
                if (recipe.notes.isNotEmpty) ...[
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
                      recipe.notes,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],

                // 制作心得部分
                Consumer<DataProvider>(
                  builder: (context, dataProvider, child) {
                    final cookingRecords = dataProvider.getCookingRecordsByRecipe(recipe.id);
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
              if (rating > 0) {
                Provider.of<DataProvider>(context, listen: false)
                    .incrementCookCount(recipe.id, rating, noteController.text);
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