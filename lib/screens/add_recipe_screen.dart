import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../models/recipe_step.dart' as local;
import '../services/api_service.dart';
import '../network/models/category_models.dart';
import '../network/models/recipe_models.dart' as network;
import 'category_management_screen.dart';

class AddRecipeScreen extends StatefulWidget {
  final Recipe? recipe; // 编辑模式传入菜谱

  const AddRecipeScreen({super.key, this.recipe});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _difficultyController = TextEditingController(text: '中等');
  final _prepTimeController = TextEditingController(text: '15');
  final _cookTimeController = TextEditingController(text: '30');
  final _servingsController = TextEditingController(text: '2');
  int? _selectedCategoryId;
  final List<Ingredient> _ingredients = [];
  final List<local.RecipeStep> _steps = [];
  List<CategoryResponse> _categories = [];
  bool _isPublic = true;
  bool _isLoading = false;
  bool get _isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (_isEditing) {
      _initializeEditData();
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.getCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载类别失败: $e')),
        );
      }
    }
  }

  void _initializeEditData() {
    final recipe = widget.recipe!;
    _nameController.text = recipe.name;
    _notesController.text = recipe.notes;
    // 本地模型的categoryId是String，需要转换
    _selectedCategoryId = int.tryParse(recipe.categoryId);
    _ingredients.addAll(recipe.ingredients);
    _steps.addAll(recipe.steps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      appBar: AppBar(
        title: Text(_isEditing ? '编辑菜谱' : '添加菜谱'),
        backgroundColor: const Color(0xFFE8D5B7),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextButton(
                  onPressed: _saveRecipe,
                  child: const Text('保存', style: TextStyle(color: Colors.black87)),
                ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 菜名输入
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '菜名',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入菜名';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // 分类选择
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: '分类',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _categories.map<DropdownMenuItem<int>>((category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Row(
                          children: [
                            Text(category.icon),
                            const SizedBox(width: 8),
                            Text(category.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return '请选择分类';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryManagementScreen(),
                      ),
                    ).then((_) => _loadCategories());
                  },
                  icon: const Icon(Icons.settings),
                  tooltip: '管理分类',
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 难度、时间、份数
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _difficultyController,
                    decoration: const InputDecoration(
                      labelText: '难度',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _prepTimeController,
                    decoration: const InputDecoration(
                      labelText: '准备时间(分钟)',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cookTimeController,
                    decoration: const InputDecoration(
                      labelText: '烹饪时间(分钟)',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _servingsController,
                    decoration: const InputDecoration(
                      labelText: '份数',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 公开设置
            SwitchListTile(
              title: const Text('公开菜谱'),
              subtitle: const Text('其他用户可以看到这个菜谱'),
              value: _isPublic,
              onChanged: (value) {
                setState(() {
                  _isPublic = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // 备注输入
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: '备注（可选）',
                hintText: '记录一些制作心得或特殊做法...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 24),
            
            // 配料部分
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('配料', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _addIngredient,
                  icon: const Icon(Icons.add),
                  label: const Text('添加配料'),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            ..._ingredients.asMap().entries.map((entry) {
              final index = entry.key;
              final ingredient = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(ingredient.name),
                  subtitle: Text('${ingredient.quantity} ${ingredient.unit}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeIngredient(index),
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 24),
            
            // 制作步骤部分
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('制作步骤', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _addStep,
                  icon: const Icon(Icons.add),
                  label: const Text('添加步骤'),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            ..._steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(step.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeStep(index),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _addIngredient() {
    showDialog(
      context: context,
      builder: (context) => _IngredientDialog(
        onAdd: (ingredient) {
          setState(() {
            _ingredients.add(ingredient);
          });
        },
      ),
    );
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _addStep() {
    showDialog(
      context: context,
      builder: (context) => _StepDialog(
        stepNumber: _steps.length + 1,
        onAdd: (step) {
          setState(() {
            _steps.add(step);
          });
        },
      ),
    );
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
      // 重新排序
      for (int i = 0; i < _steps.length; i++) {
        _steps[i].order = i + 1;
      }
    });
  }

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final request = network.CreateRecipeRequest(
          title: _nameController.text,
          description: _notesController.text,
          categoryId: _selectedCategoryId,
          images: [],
          tags: [],
          difficulty: _difficultyController.text,
          prepTime: int.tryParse(_prepTimeController.text) ?? 15,
          cookTime: int.tryParse(_cookTimeController.text) ?? 30,
          servings: int.tryParse(_servingsController.text) ?? 2,
          isPublic: _isPublic,
          ingredients: _ingredients.map((ing) => network.RecipeIngredient(
            id: 0,
            name: ing.name,
            amount: ing.quantity.toString(),
            unit: ing.unit,
          )).toList(),
          steps: _steps.map((step) => network.RecipeStep(
            id: 0,
            stepNumber: step.order,
            description: step.description,
            images: [],
          )).toList(),
        );
        
        await ApiService.createRecipe(request);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('菜谱保存成功')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('保存失败: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _difficultyController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    super.dispose();
  }
}

// 添加配料对话框
class _IngredientDialog extends StatefulWidget {
  final Function(Ingredient) onAdd;

  const _IngredientDialog({required this.onAdd});

  @override
  State<_IngredientDialog> createState() => _IngredientDialogState();
}

class _IngredientDialogState extends State<_IngredientDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加配料'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: '配料名称'),
          ),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(labelText: '数量'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _unitController,
            decoration: const InputDecoration(labelText: '单位'),
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
              final ingredient = Ingredient(
                id: const Uuid().v4(),
                name: _nameController.text,
                categoryId: '',
                quantity: double.tryParse(_quantityController.text) ?? 0,
                unit: _unitController.text,
              );
              widget.onAdd(ingredient);
              Navigator.pop(context);
            }
          },
          child: const Text('添加'),
        ),
      ],
    );
  }
}

// 添加步骤对话框
class _StepDialog extends StatefulWidget {
  final int stepNumber;
  final Function(local.RecipeStep) onAdd;

  const _StepDialog({required this.stepNumber, required this.onAdd});

  @override
  State<_StepDialog> createState() => _StepDialogState();
}

class _StepDialogState extends State<_StepDialog> {
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('添加步骤 ${widget.stepNumber}'),
      content: TextField(
        controller: _descriptionController,
        decoration: const InputDecoration(labelText: '步骤描述'),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            if (_descriptionController.text.isNotEmpty) {
              final step = local.RecipeStep(
                order: widget.stepNumber,
                description: _descriptionController.text,
              );
              widget.onAdd(step);
              Navigator.pop(context);
            }
          },
          child: const Text('添加'),
        ),
      ],
    );
  }
}