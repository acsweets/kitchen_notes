import 'package:flutter/material.dart';
import '../models/category.dart' as model;

class CategoryTabs extends StatelessWidget {
  final List<model.Category> categories;
  final String selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // 全部分类
          _buildCategoryChip(
            '全部',
            '',
            selectedCategoryId.isEmpty,
          ),
          const SizedBox(width: 8),
          
          // 各个分类
          ...categories.map((category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildCategoryChip(
                  category.name,
                  category.id,
                  selectedCategoryId == category.id,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String categoryId, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onCategorySelected(selected ? categoryId : '');
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFFB8860B),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFFB8860B) : Colors.grey[300]!,
        ),
      ),
    );
  }
}