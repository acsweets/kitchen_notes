import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../theme/app_colors.dart';
import '../providers/data_provider.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../models/recipe_step.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_buttons.dart';

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
  String _selectedCategoryId = '';
  final List<Ingredient> _ingredients = [];
  final List<RecipeStep> _steps = [];
  bool get _isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _initializeEditData();
    }
  }

  void _initializeEditData() {
    final recipe = widget.recipe!;
    _nameController.text = recipe.name;
    _notesController.text = recipe.notes;
    _selectedCategoryId = recipe.categoryId;
    _ingredients.addAll(recipe.ingredients);
    _steps.addAll(recipe.steps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑菜谱' : '添加菜谱'),
        actions: [
          TextButton(
            onPressed: _saveRecipe,
            child: const Text('保存'),
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
            Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return DropdownButtonFormField<String>(
                  value: _selectedCategoryId.isEmpty ? null : _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: '分类',
                  ),
                  items: dataProvider.recipeCategories.map<DropdownMenuItem<String>>((category) {
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请选择分类';
                    }
                    return null;
                  },
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // 备注输入
            CustomTextField(
              controller: _notesController,
              labelText: '备注（可选）',
              hintText: '记录一些制作心得或特殊做法...',
              maxLines: 3,
            ),
            
            const SizedBox(height: 24),
            
            // 配料部分
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('配料', style: Theme.of(context).textTheme.headlineLarge),
                SecondaryButton(
                  text: '添加配料',
                  icon: Icons.add,
                  onPressed: _addIngredient,
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
                Text('制作步骤', style: Theme.of(context).textTheme.headlineLarge),
                SecondaryButton(
                  text: '添加步骤',
                  icon: Icons.add,
                  onPressed: _addStep,
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

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      
      if (_isEditing) {
        // 编辑模式
        final updatedRecipe = Recipe(
          id: widget.recipe!.id,
          name: _nameController.text,
          categoryId: _selectedCategoryId,
          coverImage: widget.recipe!.coverImage,
          ingredients: _ingredients,
          steps: _steps,
          cookCount: widget.recipe!.cookCount,
          rating: widget.recipe!.rating,
          createdAt: widget.recipe!.createdAt,
          updatedAt: now,
          isFavorite: widget.recipe!.isFavorite,
          notes: _notesController.text,
        );
        Provider.of<DataProvider>(context, listen: false).updateRecipe(updatedRecipe);
      } else {
        // 新增模式
        final recipe = Recipe(
          id: const Uuid().v4(),
          name: _nameController.text,
          categoryId: _selectedCategoryId,
          ingredients: _ingredients,
          steps: _steps,
          createdAt: now,
          updatedAt: now,
          notes: _notesController.text,
        );
        Provider.of<DataProvider>(context, listen: false).addRecipe(recipe);
      }
      
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
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
          CustomTextField(
            controller: _nameController,
            labelText: '配料名称',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _quantityController,
            labelText: '数量',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _unitController,
            labelText: '单位',
          ),
        ],
      ),
      actions: [
        SecondaryButton(
          text: '取消',
          onPressed: () => Navigator.pop(context),
        ),
        PrimaryButton(
          text: '添加',
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
        ),
      ],
    );
  }
}

// 添加步骤对话框
class _StepDialog extends StatefulWidget {
  final int stepNumber;
  final Function(RecipeStep) onAdd;

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
      content: CustomTextField(
        controller: _descriptionController,
        labelText: '步骤描述',
        maxLines: 3,
      ),
      actions: [
        SecondaryButton(
          text: '取消',
          onPressed: () => Navigator.pop(context),
        ),
        PrimaryButton(
          text: '添加',
          onPressed: () {
            if (_descriptionController.text.isNotEmpty) {
              final step = RecipeStep(
                order: widget.stepNumber,
                description: _descriptionController.text,
              );
              widget.onAdd(step);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}