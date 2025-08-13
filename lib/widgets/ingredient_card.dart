import 'package:flutter/material.dart';
import '../models/ingredient.dart';

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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 食材图标
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getIconColor(),
                  borderRadius: BorderRadius.circular(25),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${ingredient.quantity} ${ingredient.unit}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
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
              
              // 删除按钮
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.grey),
              ),
            ],
          ),
        ),
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
        return Colors.green;
      case 'ingredient_meat':
        return Colors.red[400]!;
      case 'ingredient_seafood':
        return Colors.blue;
      case 'ingredient_seasoning':
        return Colors.orange;
      case 'ingredient_staple':
        return Colors.brown;
      default:
        return Colors.grey;
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
      return Colors.red;
    } else if (ingredient.isExpiringSoon) {
      return Colors.orange[700]!;
    } else {
      return Colors.grey[600]!;
    }
  }
}