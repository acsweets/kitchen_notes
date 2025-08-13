import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/data_provider.dart';
import '../models/ingredient.dart';
import '../models/category.dart' as model;
import '../widgets/ingredient_card.dart';
import '../widgets/category_tabs.dart';

class IngredientManagementScreen extends StatefulWidget {
  const IngredientManagementScreen({super.key});

  @override
  State<IngredientManagementScreen> createState() => _IngredientManagementScreenState();
}

class _IngredientManagementScreenState extends State<IngredientManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategoryId = '';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      appBar: AppBar(
        title: const Text('食材管理'),
        backgroundColor: const Color(0xFFE8D5B7),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => _showCategoryManagement(),
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
                hintText: '搜索食材...',
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
                categories: dataProvider.ingredientCategories,
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: (categoryId) {
                  setState(() {
                    _selectedCategoryId = categoryId;
                  });
                },
              );
            },
          ),

          // 即将过期提醒
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              final expiringSoon = dataProvider.expiringSoonIngredients;
              if (expiringSoon.isEmpty) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  border: Border.all(color: Colors.orange[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange[700]),
                        const SizedBox(width: 8),
                        Text(
                          '即将过期提醒',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...expiringSoon.take(3).map((ingredient) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${ingredient.name} - ${_getExpiryText(ingredient)}',
                            style: TextStyle(color: Colors.orange[700]),
                          ),
                        )),
                  ],
                ),
              );
            },
          ),

          // 食材列表
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                List<Ingredient> ingredients = _getFilteredIngredients(dataProvider);

                if (ingredients.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('还没有食材，快来添加吧！',
                             style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = ingredients[index];
                    return IngredientCard(
                      ingredient: ingredient,
                      onTap: () => _editIngredient(ingredient),
                      onDelete: () => _deleteIngredient(ingredient.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addIngredient(),
        backgroundColor: const Color(0xFFB8860B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<Ingredient> _getFilteredIngredients(DataProvider dataProvider) {
    List<Ingredient> ingredients = dataProvider.ingredients;

    // 按搜索关键词过滤
    if (_searchQuery.isNotEmpty) {
      ingredients = dataProvider.searchIngredients(_searchQuery);
    }

    // 按分类过滤
    if (_selectedCategoryId.isNotEmpty) {
      ingredients = ingredients.where((i) => i.categoryId == _selectedCategoryId).toList();
    }

    return ingredients;
  }

  String _getExpiryText(Ingredient ingredient) {
    final days = ingredient.daysUntilExpiry;
    if (days == null) return '';
    if (days < 0) return '已过期${-days}天';
    if (days == 0) return '今天过期';
    return '还有${days}天过期';
  }

  void _addIngredient() {
    showDialog(
      context: context,
      builder: (context) => _IngredientDialog(
        onSave: (ingredient) {
          Provider.of<DataProvider>(context, listen: false).addIngredient(ingredient);
        },
      ),
    );
  }

  void _editIngredient(Ingredient ingredient) {
    showDialog(
      context: context,
      builder: (context) => _IngredientDialog(
        ingredient: ingredient,
        onSave: (updatedIngredient) {
          Provider.of<DataProvider>(context, listen: false).updateIngredient(updatedIngredient);
        },
      ),
    );
  }

  void _deleteIngredient(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除食材'),
        content: const Text('确定要删除这个食材吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<DataProvider>(context, listen: false).deleteIngredient(id);
              Navigator.pop(context);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showCategoryManagement() {
    showDialog(
      context: context,
      builder: (context) => _CategoryManagementDialog(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// 食材添加/编辑对话框
class _IngredientDialog extends StatefulWidget {
  final Ingredient? ingredient;
  final Function(Ingredient) onSave;

  const _IngredientDialog({this.ingredient, required this.onSave});

  @override
  State<_IngredientDialog> createState() => _IngredientDialogState();
}

class _IngredientDialogState extends State<_IngredientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  String _selectedCategoryId = '';
  DateTime? _expiryDate;

  bool get _isEditing => widget.ingredient != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final ingredient = widget.ingredient!;
      _nameController.text = ingredient.name;
      _quantityController.text = ingredient.quantity.toString();
      _unitController.text = ingredient.unit;
      _selectedCategoryId = ingredient.categoryId;
      _expiryDate = ingredient.expiryDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? '编辑食材' : '添加食材'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '食材名称'),
                validator: (value) => value?.isEmpty == true ? '请输入食材名称' : null,
              ),
              const SizedBox(height: 16),
              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  return DropdownButtonFormField<String>(
                    value: _selectedCategoryId.isEmpty ? null : _selectedCategoryId,
                    decoration: const InputDecoration(labelText: '分类'),
                    items: dataProvider.ingredientCategories.map<DropdownMenuItem<String>>((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value ?? '';
                      });
                    },
                    validator: (value) => value?.isEmpty == true ? '请选择分类' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(labelText: '数量'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return '请输入数量';
                        if (double.tryParse(value!) == null) return '请输入有效数字';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(labelText: '单位'),
                      validator: (value) => value?.isEmpty == true ? '请输入单位' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('保质期'),
                subtitle: Text(_expiryDate == null 
                    ? '点击设置保质期' 
                    : '${_expiryDate!.year}-${_expiryDate!.month.toString().padLeft(2, '0')}-${_expiryDate!.day.toString().padLeft(2, '0')}'),
                trailing: _expiryDate == null 
                    ? const Icon(Icons.calendar_today)
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _expiryDate = null;
                          });
                        },
                      ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 7)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _expiryDate = date;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: _saveIngredient,
          child: const Text('保存'),
        ),
      ],
    );
  }

  void _saveIngredient() {
    if (_formKey.currentState!.validate()) {
      final ingredient = Ingredient(
        id: _isEditing ? widget.ingredient!.id : const Uuid().v4(),
        name: _nameController.text,
        categoryId: _selectedCategoryId,
        quantity: double.parse(_quantityController.text),
        unit: _unitController.text,
        expiryDate: _expiryDate,
      );
      
      widget.onSave(ingredient);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    super.dispose();
  }
}

// 分类管理对话框
class _CategoryManagementDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('分类管理'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Consumer<DataProvider>(
          builder: (context, dataProvider, child) {
            final categories = dataProvider.ingredientCategories;
            
            return Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _addCategory(context),
                  icon: const Icon(Icons.add),
                  label: const Text('添加分类'),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ListTile(
                        title: Text(category.name),
                        subtitle: Text(category.isDefault ? '默认分类' : '自定义分类'),
                        trailing: category.isDefault 
                            ? null 
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _editCategory(context, category),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteCategory(context, category.id),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
      ],
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
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: '分类名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newCategory = model.Category(
                  id: isEditing ? category.id : const Uuid().v4(),
                  name: nameController.text,
                  type: 'ingredient',
                  isDefault: false,
                );
                
                if (isEditing) {
                  Provider.of<DataProvider>(context, listen: false).updateCategory(newCategory);
                } else {
                  Provider.of<DataProvider>(context, listen: false).addCategory(newCategory);
                }
                Navigator.pop(context);
              }
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
        content: const Text('确定要删除这个分类吗？如果分类下有食材将无法删除。'),
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
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}