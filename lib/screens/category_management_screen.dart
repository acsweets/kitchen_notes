import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../network/models/category_models.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  List<CategoryResponse> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.getCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载类别失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      appBar: AppBar(
        title: const Text('类别管理'),
        backgroundColor: const Color(0xFFE8D5B7),
        actions: [
          IconButton(
            onPressed: () => _showAddCategoryDialog(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Text(
                      category.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(category.name),
                    subtitle: Text(category.description),
                    trailing: category.isDefault
                        ? const Chip(
                            label: Text('默认'),
                            backgroundColor: Colors.grey,
                          )
                        : PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('编辑'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('删除'),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditCategoryDialog(category);
                              } else if (value == 'delete') {
                                _deleteCategory(category);
                              }
                            },
                          ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => _CategoryDialog(
        onSave: (name, description, icon) async {
          try {
            await ApiService.createCategory(
              CreateCategoryRequest(
                name: name,
                description: description,
                icon: icon,
              ),
            );
            _loadCategories();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('类别创建成功')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('创建失败: $e')),
              );
            }
          }
        },
      ),
    );
  }

  void _showEditCategoryDialog(CategoryResponse category) {
    showDialog(
      context: context,
      builder: (context) => _CategoryDialog(
        category: category,
        onSave: (name, description, icon) async {
          try {
            await ApiService.updateCategory(
              category.id,
              UpdateCategoryRequest(
                name: name,
                description: description,
                icon: icon,
              ),
            );
            _loadCategories();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('类别更新成功')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('更新失败: $e')),
              );
            }
          }
        },
      ),
    );
  }

  void _deleteCategory(CategoryResponse category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除类别"${category.name}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ApiService.deleteCategory(category.id);
                _loadCategories();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('类别删除成功')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('删除失败: $e')),
                  );
                }
              }
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}

class _CategoryDialog extends StatefulWidget {
  final CategoryResponse? category;
  final Function(String name, String description, String icon) onSave;

  const _CategoryDialog({this.category, required this.onSave});

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedIcon = '🍽️';

  final List<String> _availableIcons = [
    '🍽️', '🏠', '🌶️', '🦐', '🔥', '🥘', '🐟', '🦀', '🍖', '🍰', '🍲', '🥬', '🍞'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _descriptionController.text = widget.category!.description;
      _selectedIcon = widget.category!.icon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? '添加类别' : '编辑类别'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: '类别名称'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: '描述'),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          const Text('选择图标:'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _availableIcons.map((icon) {
              return GestureDetector(
                onTap: () => setState(() => _selectedIcon = icon),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedIcon == icon ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(icon, style: const TextStyle(fontSize: 24)),
                ),
              );
            }).toList(),
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
            if (_nameController.text.isNotEmpty) {
              widget.onSave(
                _nameController.text,
                _descriptionController.text,
                _selectedIcon,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}