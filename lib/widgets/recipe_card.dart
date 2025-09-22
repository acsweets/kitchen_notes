import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/recipe.dart';
import '../providers/data_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/full_screen_image_viewer.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 封面图片
              GestureDetector(
                onTap: recipe.coverImage != null ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImageViewer(imagePath: recipe.coverImage!),
                  ),
                ) : null,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primaryContainer, AppColors.surfaceVariant],
                    ),
                  ),
                  child: recipe.coverImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(recipe.coverImage!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.restaurant_menu,
                                size: 32,
                                color: AppColors.primary,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.restaurant_menu,
                          size: 32,
                          color: AppColors.primary,
                        ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // 菜谱信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${recipe.ingredients.length}种食材 • ${recipe.steps.length}个步骤',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (recipe.cookCount > 0) ...[
                          Icon(Icons.local_fire_department, 
                               size: 16, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            '做过${recipe.cookCount}次',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.warning,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (recipe.rating > 0) ...[
                          Icon(Icons.star, size: 16, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            recipe.rating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // 收藏按钮
              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  final currentRecipe = dataProvider.recipes.firstWhere((r) => r.id == recipe.id);
                  return IconButton(
                    onPressed: () {
                      dataProvider.toggleFavorite(recipe.id);
                    },
                    icon: Icon(
                      currentRecipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: currentRecipe.isFavorite ? AppColors.error : AppColors.textTertiary,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}