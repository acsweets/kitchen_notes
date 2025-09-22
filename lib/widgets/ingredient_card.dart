import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../theme/app_colors.dart';

class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const IngredientCard({
    super.key,
    required this.ingredient,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(ingredient.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text('删除', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('删除食材'),
            content: Text('确定要删除「${ingredient.name}」吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('删除'),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (direction) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 食材图标
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getIconColor(),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    _getIngredientIcon(),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // 食材信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ingredient.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${ingredient.quantity} ${ingredient.unit}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (ingredient.expiryDate != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 16,
                              color: _getExpiryColor(),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getExpiryText(),
                              style: TextStyle(
                                fontSize: 12,
                                color: _getExpiryColor(),
                                fontWeight: ingredient.isExpiringSoon || ingredient.isExpired 
                                    ? FontWeight.bold 
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                // 状态指示器和操作按钮
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 过期状态指示点
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getExpiryColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 更多操作按钮
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.more_vert,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        onSelected: (value) {
                          if (value == 'edit') {
                            onTap();
                          } else if (value == 'delete') {
                            _showDeleteDialog(context);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: 8),
                                Text('编辑'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 18, color: AppColors.error),
                                SizedBox(width: 8),
                                Text('删除', style: TextStyle(color: AppColors.error)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除食材'),
        content: Text('确定要删除「${ingredient.name}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  IconData _getIngredientIcon() {
    switch (ingredient.categoryId) {
      case 'ingredient_vegetable':
        return Icons.eco;
      case 'ingredient_meat':
        return Icons.set_meal;
      case 'ingredient_seafood':
        return Icons.phishing;
      case 'ingredient_seasoning':
        return Icons.grain;
      case 'ingredient_staple':
        return Icons.rice_bowl;
      default:
        return Icons.inventory_2;
    }
  }

  Color _getIconColor() {
    switch (ingredient.categoryId) {
      case 'ingredient_vegetable':
        return AppColors.success;
      case 'ingredient_meat':
        return AppColors.error;
      case 'ingredient_seafood':
        return AppColors.primary;
      case 'ingredient_seasoning':
        return AppColors.warning;
      case 'ingredient_staple':
        return AppColors.secondary;
      default:
        return AppColors.textTertiary;
    }
  }

  String _getExpiryText() {
    final days = ingredient.daysUntilExpiry;
    if (days == null) return '';
    
    if (days < 0) {
      return '已过期${-days}天';
    } else if (days == 0) {
      return '今天过期';
    } else if (days == 1) {
      return '明天过期';
    } else {
      return '还有${days}天过期';
    }
  }

  Color _getExpiryColor() {
    if (ingredient.isExpired) {
      return AppColors.error;
    } else if (ingredient.isExpiringSoon) {
      return AppColors.warning;
    } else {
      return AppColors.success;
    }
  }
}