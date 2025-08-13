import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/data_provider.dart';
import '../models/category.dart' as model;

class RecipeCategoryManagementScreen extends StatelessWidget {
  const RecipeCategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      appBar: AppBar(
        title: const Text('菜谱分类管理'),
        backgroundColor: const Color(0xFFE8D5B7),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          final categories = dataProvider.recipeCategories;
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final recipeCount = dataProvider.getRecipesByCategory(category.id).length;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFB8860B),
                    child: Text(
                      category.name.substring(0, 1),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${recipeCount}个菜谱'),
                      if (category.isDefault)
                        const Text(
                          '默认分类',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                    ],
                  ),
                  trailing: category.isDefault 
                      ? null 
                      : PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editCategory(context, category);
                            } else if (value == 'delete') {
                              _deleteCategory(context, category.id);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 8),
                                  Text('编辑'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 8),
                                  Text('删除'),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCategory(context),
        backgroundColor: const Color(0xFFB8860B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addCategory(BuildContext context) {
    _showCategoryDialog(context, null);
  }

  void _editCategory(BuildContext context, model.Category category) {
    _showCategoryDialog(context, category);
  }

  void _showCategoryDialog(BuildContext context, model.Category? category) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final isEditing = category != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? '编辑分类' : '添加分类'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '分类名称',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            const Text(
              '提示：分类名称应该简洁明了，如"川菜"、"粤菜"、"素食"等',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入分类名称')),
                );
                return;
              }

              final dataProvider = Provider.of<DataProvider>(context, listen: false);
              
              // 检查名称是否重复
              final existingCategory = dataProvider.recipeCategories
                  .where((c) => c.name == name && c.id != (category?.id ?? ''))
                  .firstOrNull;
              
              if (existingCategory != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('分类名称已存在')),
                );
                return;
              }

              final newCategory = model.Category(
                id: isEditing ? category!.id : 'recipe_${const Uuid().v4()}',
                name: name,
                type: 'recipe',
                isDefault: false,
              );
              
              if (isEditing) {
                dataProvider.updateCategory(newCategory);
              } else {
                dataProvider.addCategory(newCategory);
              }
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isEditing ? '分类已更新' : '分类已添加')),
              );
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(BuildContext context, String categoryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除分类'),
        content: const Text('确定要删除这个分类吗？如果分类下有菜谱将无法删除。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              try {
                Provider.of<DataProvider>(context, listen: false).deleteCategory(categoryId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('分类已删除')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}