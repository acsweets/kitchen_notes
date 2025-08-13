# Hive 数据库使用手册

## 目录
1. [Hive 简介](#hive-简介)
2. [项目中的 Hive 配置](#项目中的-hive-配置)
3. [数据模型定义](#数据模型定义)
4. [适配器生成](#适配器生成)
5. [数据库初始化](#数据库初始化)
6. [CRUD 操作](#crud-操作)
7. [数据查询](#数据查询)
8. [数据备份与恢复](#数据备份与恢复)
9. [性能优化](#性能优化)
10. [常见问题与解决方案](#常见问题与解决方案)

## Hive 简介

### 什么是 Hive？
Hive 是一个轻量级、快速的 NoSQL 数据库，专为 Flutter 和 Dart 应用设计。它具有以下特点：

- **快速**: 比 SQLite 快 2-3 倍
- **轻量**: 核心库只有几百 KB
- **类型安全**: 支持强类型数据存储
- **跨平台**: 支持所有 Flutter 平台
- **易用**: API 简单直观

### 为什么选择 Hive？
在灶边记项目中选择 Hive 的原因：

1. **本地存储**: 无需网络连接，完全离线工作
2. **性能优异**: 快速读写，适合频繁的菜谱查询
3. **对象存储**: 直接存储 Dart 对象，无需 SQL 映射
4. **易于维护**: 代码简洁，维护成本低

## 项目中的 Hive 配置

### 依赖配置

在 `pubspec.yaml` 中添加以下依赖：

```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.9
```

### 项目结构

```
lib/
├── models/                 # 数据模型
│   ├── category.dart      # 分类模型
│   ├── ingredient.dart    # 食材模型
│   ├── recipe.dart        # 菜谱模型
│   ├── recipe_step.dart   # 制作步骤模型
│   └── cooking_record.dart # 制作记录模型
├── providers/             # 数据提供者
│   └── data_provider.dart # 主要数据管理类
└── data/                  # 默认数据
    ├── default_data.dart  # 默认分类和食材
    └── default_recipes.dart # 默认菜谱
```

## 数据模型定义

### 1. 基础模型结构

每个 Hive 模型都需要：
- 继承或使用 `@HiveType` 注解
- 为每个字段添加 `@HiveField` 注解
- 指定唯一的 `typeId`

### 2. Category 模型

```dart
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 0)  // 唯一标识符
class Category {
  @HiveField(0)  // 字段索引
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String type; // 'recipe' 或 'ingredient'

  @HiveField(3)
  bool isDefault;

  Category({
    required this.id,
    required this.name,
    required this.type,
    this.isDefault = false,
  });
}
```

### 3. Ingredient 模型

```dart
import 'package:hive/hive.dart';

part 'ingredient.g.dart';

@HiveType(typeId: 1)
class Ingredient {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String categoryId;

  @HiveField(3)
  double quantity;

  @HiveField(4)
  String unit;

  @HiveField(5)
  DateTime? expiryDate;

  Ingredient({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.quantity,
    required this.unit,
    this.expiryDate,
  });

  // 业务逻辑方法
  int? get daysUntilExpiry {
    if (expiryDate == null) return null;
    final now = DateTime.now();
    final difference = expiryDate!.difference(DateTime(now.year, now.month, now.day));
    return difference.inDays;
  }

  bool get isExpiringSoon {
    final days = daysUntilExpiry;
    return days != null && days <= 3 && days >= 0;
  }

  bool get isExpired {
    final days = daysUntilExpiry;
    return days != null && days < 0;
  }
}
```

### 4. Recipe 模型

```dart
import 'package:hive/hive.dart';
import 'ingredient.dart';
import 'recipe_step.dart';

part 'recipe.g.dart';

@HiveType(typeId: 3)
class Recipe {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String categoryId;

  @HiveField(3)
  String? coverImage;

  @HiveField(4)
  List<Ingredient> ingredients;

  @HiveField(5)
  List<RecipeStep> steps;

  @HiveField(6)
  int cookCount;

  @HiveField(7)
  double rating;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  @HiveField(10)
  bool isFavorite;

  @HiveField(11)
  String notes;

  Recipe({
    required this.id,
    required this.name,
    required this.categoryId,
    this.coverImage,
    this.ingredients = const [],
    this.steps = const [],
    this.cookCount = 0,
    this.rating = 0.0,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.notes = '',
  });
}
```

### 5. TypeId 分配规则

在项目中，我们按以下规则分配 typeId：

```dart
// typeId 分配表
@HiveType(typeId: 0) // Category
@HiveType(typeId: 1) // Ingredient  
@HiveType(typeId: 2) // RecipeStep
@HiveType(typeId: 3) // Recipe
@HiveType(typeId: 4) // CookingRecord
// 5-9 预留给未来扩展
```

**重要**: typeId 必须唯一且不能更改，否则会导致数据不兼容。

## 适配器生成

### 1. 生成命令

```bash
# 生成适配器
flutter packages pub run build_runner build

# 强制重新生成（删除冲突文件）
flutter packages pub run build_runner build --delete-conflicting-outputs

# 监听文件变化自动生成
flutter packages pub run build_runner watch
```

### 2. 生成的文件

每个模型会生成对应的 `.g.dart` 文件：

```
models/
├── category.dart
├── category.g.dart      # 自动生成
├── ingredient.dart
├── ingredient.g.dart    # 自动生成
└── ...
```

### 3. 适配器内容示例

```dart
// category.g.dart (自动生成，不要手动修改)
class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 0;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      isDefault: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.isDefault);
  }
}
```

## 数据库初始化

### 1. DataProvider 初始化

```dart
class DataProvider extends ChangeNotifier {
  // 数据库盒子
  late Box<Category> _categoryBox;
  late Box<Ingredient> _ingredientBox;
  late Box<Recipe> _recipeBox;
  late Box<CookingRecord> _cookingRecordBox;

  // 内存数据
  List<Category> _categories = [];
  List<Ingredient> _ingredients = [];
  List<Recipe> _recipes = [];
  List<CookingRecord> _cookingRecords = [];

  Future<void> initializeData() async {
    // 1. 初始化 Hive
    await Hive.initFlutter();
    
    // 2. 注册适配器
    _registerAdapters();
    
    // 3. 打开数据库盒子
    await _openBoxes();
    
    // 4. 初始化默认数据
    await _initializeDefaultData();
    
    // 5. 加载数据到内存
    _loadData();
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(IngredientAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(RecipeStepAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(RecipeAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(CookingRecordAdapter());
    }
  }

  Future<void> _openBoxes() async {
    _categoryBox = await Hive.openBox<Category>('categories');
    _ingredientBox = await Hive.openBox<Ingredient>('ingredients');
    _recipeBox = await Hive.openBox<Recipe>('recipes');
    _cookingRecordBox = await Hive.openBox<CookingRecord>('cooking_records');
  }

  void _loadData() {
    _categories = _categoryBox.values.toList();
    _ingredients = _ingredientBox.values.toList();
    _recipes = _recipeBox.values.toList();
    _cookingRecords = _cookingRecordBox.values.toList();
    notifyListeners();
  }
}
```

### 2. 默认数据初始化

```dart
Future<void> _initializeDefaultData() async {
  // 初始化默认分类
  if (_categoryBox.isEmpty) {
    final defaultRecipeCategories = DefaultData.getDefaultRecipeCategories();
    final defaultIngredientCategories = DefaultData.getDefaultIngredientCategories();
    
    for (var category in [...defaultRecipeCategories, ...defaultIngredientCategories]) {
      await _categoryBox.put(category.id, category);
    }
  }

  // 初始化默认食材
  if (_ingredientBox.isEmpty) {
    final defaultIngredients = DefaultData.getDefaultIngredients();
    for (var ingredient in defaultIngredients) {
      await _ingredientBox.put(ingredient.id, ingredient);
    }
  }

  // 初始化默认菜谱
  if (_recipeBox.isEmpty) {
    final defaultRecipes = DefaultRecipes.getDefaultRecipes();
    for (var recipe in defaultRecipes) {
      await _recipeBox.put(recipe.id, recipe);
    }
  }
}
```

## CRUD 操作

### 1. Create (创建)

```dart
// 添加菜谱
Future<void> addRecipe(Recipe recipe) async {
  // 1. 保存到数据库
  await _recipeBox.put(recipe.id, recipe);
  
  // 2. 更新内存数据
  _recipes.add(recipe);
  
  // 3. 通知UI更新
  notifyListeners();
}

// 批量添加
Future<void> addRecipes(List<Recipe> recipes) async {
  final Map<String, Recipe> recipeMap = {
    for (var recipe in recipes) recipe.id: recipe
  };
  
  await _recipeBox.putAll(recipeMap);
  _recipes.addAll(recipes);
  notifyListeners();
}
```

### 2. Read (读取)

```dart
// 获取所有菜谱
List<Recipe> get recipes => _recipes;

// 根据ID获取菜谱
Recipe? getRecipeById(String id) {
  try {
    return _recipes.firstWhere((recipe) => recipe.id == id);
  } catch (e) {
    return null;
  }
}

// 根据分类获取菜谱
List<Recipe> getRecipesByCategory(String categoryId) {
  return _recipes.where((recipe) => recipe.categoryId == categoryId).toList();
}

// 获取收藏菜谱
List<Recipe> get favoriteRecipes => 
    _recipes.where((recipe) => recipe.isFavorite).toList();

// 分页获取菜谱
List<Recipe> getRecipesPaginated(int page, int pageSize) {
  final startIndex = page * pageSize;
  final endIndex = startIndex + pageSize;
  
  if (startIndex >= _recipes.length) return [];
  
  return _recipes.sublist(
    startIndex, 
    endIndex > _recipes.length ? _recipes.length : endIndex
  );
}
```

### 3. Update (更新)

```dart
// 更新菜谱
Future<void> updateRecipe(Recipe recipe) async {
  // 1. 更新数据库
  await _recipeBox.put(recipe.id, recipe);
  
  // 2. 更新内存数据
  final index = _recipes.indexWhere((r) => r.id == recipe.id);
  if (index != -1) {
    _recipes[index] = recipe;
    notifyListeners();
  }
}

// 切换收藏状态
Future<void> toggleFavorite(String recipeId) async {
  final recipe = _recipes.firstWhere((r) => r.id == recipeId);
  recipe.isFavorite = !recipe.isFavorite;
  recipe.updatedAt = DateTime.now();
  await updateRecipe(recipe);
}

// 增加制作次数
Future<void> incrementCookCount(String recipeId, double rating, String notes) async {
  final recipe = _recipes.firstWhere((r) => r.id == recipeId);
  recipe.cookCount++;
  
  // 更新平均评分
  if (recipe.rating == 0) {
    recipe.rating = rating;
  } else {
    recipe.rating = (recipe.rating + rating) / 2;
  }
  
  recipe.updatedAt = DateTime.now();
  await updateRecipe(recipe);
  
  // 添加制作记录
  final cookingRecord = CookingRecord(
    id: const Uuid().v4(),
    recipeId: recipeId,
    recipeName: recipe.name,
    cookingDate: DateTime.now(),
    rating: rating,
    notes: notes,
  );
  await addCookingRecord(cookingRecord);
}
```

### 4. Delete (删除)

```dart
// 删除菜谱
Future<void> deleteRecipe(String id) async {
  // 1. 从数据库删除
  await _recipeBox.delete(id);
  
  // 2. 从内存删除
  _recipes.removeWhere((recipe) => recipe.id == id);
  
  // 3. 删除相关的制作记录
  final relatedRecords = _cookingRecords.where((record) => record.recipeId == id).toList();
  for (var record in relatedRecords) {
    await deleteCookingRecord(record.id);
  }
  
  notifyListeners();
}

// 批量删除
Future<void> deleteRecipes(List<String> ids) async {
  for (String id in ids) {
    await _recipeBox.delete(id);
  }
  
  _recipes.removeWhere((recipe) => ids.contains(recipe.id));
  notifyListeners();
}

// 清空所有数据
Future<void> clearAllData() async {
  await _categoryBox.clear();
  await _ingredientBox.clear();
  await _recipeBox.clear();
  await _cookingRecordBox.clear();
  
  _categories.clear();
  _ingredients.clear();
  _recipes.clear();
  _cookingRecords.clear();
  
  notifyListeners();
}
```

## 数据查询

### 1. 基础查询

```dart
// 搜索菜谱
List<Recipe> searchRecipes(String query) {
  if (query.isEmpty) return _recipes;
  
  final lowerQuery = query.toLowerCase();
  
  return _recipes.where((recipe) {
    // 按菜名搜索
    if (recipe.name.toLowerCase().contains(lowerQuery)) {
      return true;
    }
    
    // 按食材搜索
    if (recipe.ingredients.any((ingredient) => 
        ingredient.name.toLowerCase().contains(lowerQuery))) {
      return true;
    }
    
    // 按备注搜索
    if (recipe.notes.toLowerCase().contains(lowerQuery)) {
      return true;
    }
    
    return false;
  }).toList();
}

// 高级搜索
List<Recipe> advancedSearch({
  String? name,
  String? categoryId,
  List<String>? ingredientNames,
  int? minCookCount,
  double? minRating,
  DateTime? createdAfter,
  DateTime? createdBefore,
}) {
  return _recipes.where((recipe) {
    // 按名称过滤
    if (name != null && !recipe.name.toLowerCase().contains(name.toLowerCase())) {
      return false;
    }
    
    // 按分类过滤
    if (categoryId != null && recipe.categoryId != categoryId) {
      return false;
    }
    
    // 按食材过滤
    if (ingredientNames != null && ingredientNames.isNotEmpty) {
      final recipeIngredientNames = recipe.ingredients.map((i) => i.name.toLowerCase()).toList();
      if (!ingredientNames.every((name) => 
          recipeIngredientNames.any((recipeName) => recipeName.contains(name.toLowerCase())))) {
        return false;
      }
    }
    
    // 按制作次数过滤
    if (minCookCount != null && recipe.cookCount < minCookCount) {
      return false;
    }
    
    // 按评分过滤
    if (minRating != null && recipe.rating < minRating) {
      return false;
    }
    
    // 按创建时间过滤
    if (createdAfter != null && recipe.createdAt.isBefore(createdAfter)) {
      return false;
    }
    
    if (createdBefore != null && recipe.createdAt.isAfter(createdBefore)) {
      return false;
    }
    
    return true;
  }).toList();
}
```

### 2. 排序查询

```dart
// 按制作次数排序
List<Recipe> get frequentRecipes {
  final sorted = List<Recipe>.from(_recipes);
  sorted.sort((a, b) => b.cookCount.compareTo(a.cookCount));
  return sorted;
}

// 按评分排序
List<Recipe> get topRatedRecipes {
  final sorted = List<Recipe>.from(_recipes);
  sorted.sort((a, b) => b.rating.compareTo(a.rating));
  return sorted;
}

// 按创建时间排序
List<Recipe> get recentRecipes {
  final sorted = List<Recipe>.from(_recipes);
  sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return sorted;
}

// 自定义排序
List<Recipe> getSortedRecipes(int Function(Recipe a, Recipe b) compareFn) {
  final sorted = List<Recipe>.from(_recipes);
  sorted.sort(compareFn);
  return sorted;
}
```

### 3. 统计查询

```dart
// 获取统计信息
Map<String, dynamic> getStatistics() {
  return {
    'totalRecipes': _recipes.length,
    'totalIngredients': _ingredients.length,
    'totalCookingRecords': _cookingRecords.length,
    'favoriteRecipes': _recipes.where((r) => r.isFavorite).length,
    'averageRating': _recipes.isEmpty ? 0.0 : 
        _recipes.map((r) => r.rating).reduce((a, b) => a + b) / _recipes.length,
    'totalCookCount': _recipes.map((r) => r.cookCount).fold(0, (a, b) => a + b),
    'mostCookedRecipe': _recipes.isEmpty ? null : 
        _recipes.reduce((a, b) => a.cookCount > b.cookCount ? a : b),
  };
}

// 按分类统计菜谱数量
Map<String, int> getRecipeCountByCategory() {
  final Map<String, int> counts = {};
  
  for (var recipe in _recipes) {
    counts[recipe.categoryId] = (counts[recipe.categoryId] ?? 0) + 1;
  }
  
  return counts;
}

// 获取即将过期的食材
List<Ingredient> get expiringSoonIngredients {
  return _ingredients.where((ingredient) => ingredient.isExpiringSoon || ingredient.isExpired).toList();
}
```

## 数据备份与恢复

### 1. 数据导出

```dart
// 导出所有数据为JSON
Future<Map<String, dynamic>> exportAllData() async {
  return {
    'version': '1.0.0',
    'exportDate': DateTime.now().toIso8601String(),
    'categories': _categories.map((c) => _categoryToJson(c)).toList(),
    'ingredients': _ingredients.map((i) => _ingredientToJson(i)).toList(),
    'recipes': _recipes.map((r) => _recipeToJson(r)).toList(),
    'cookingRecords': _cookingRecords.map((cr) => _cookingRecordToJson(cr)).toList(),
  };
}

// 将数据保存到文件
Future<void> exportToFile(String filePath) async {
  final data = await exportAllData();
  final jsonString = jsonEncode(data);
  
  final file = File(filePath);
  await file.writeAsString(jsonString);
}

// 模型转JSON的辅助方法
Map<String, dynamic> _recipeToJson(Recipe recipe) {
  return {
    'id': recipe.id,
    'name': recipe.name,
    'categoryId': recipe.categoryId,
    'coverImage': recipe.coverImage,
    'ingredients': recipe.ingredients.map((i) => _ingredientToJson(i)).toList(),
    'steps': recipe.steps.map((s) => _recipeStepToJson(s)).toList(),
    'cookCount': recipe.cookCount,
    'rating': recipe.rating,
    'createdAt': recipe.createdAt.toIso8601String(),
    'updatedAt': recipe.updatedAt.toIso8601String(),
    'isFavorite': recipe.isFavorite,
    'notes': recipe.notes,
  };
}
```

### 2. 数据导入

```dart
// 从JSON导入数据
Future<void> importFromJson(Map<String, dynamic> jsonData) async {
  try {
    // 验证数据格式
    if (!_validateImportData(jsonData)) {
      throw Exception('Invalid data format');
    }
    
    // 清空现有数据（可选）
    // await clearAllData();
    
    // 导入分类
    if (jsonData['categories'] != null) {
      for (var categoryJson in jsonData['categories']) {
        final category = _categoryFromJson(categoryJson);
        await _categoryBox.put(category.id, category);
      }
    }
    
    // 导入食材
    if (jsonData['ingredients'] != null) {
      for (var ingredientJson in jsonData['ingredients']) {
        final ingredient = _ingredientFromJson(ingredientJson);
        await _ingredientBox.put(ingredient.id, ingredient);
      }
    }
    
    // 导入菜谱
    if (jsonData['recipes'] != null) {
      for (var recipeJson in jsonData['recipes']) {
        final recipe = _recipeFromJson(recipeJson);
        await _recipeBox.put(recipe.id, recipe);
      }
    }
    
    // 导入制作记录
    if (jsonData['cookingRecords'] != null) {
      for (var recordJson in jsonData['cookingRecords']) {
        final record = _cookingRecordFromJson(recordJson);
        await _cookingRecordBox.put(record.id, record);
      }
    }
    
    // 重新加载数据
    _loadData();
    
  } catch (e) {
    throw Exception('Import failed: $e');
  }
}

// 从文件导入
Future<void> importFromFile(String filePath) async {
  final file = File(filePath);
  final jsonString = await file.readAsString();
  final jsonData = jsonDecode(jsonString);
  
  await importFromJson(jsonData);
}

// JSON转模型的辅助方法
Recipe _recipeFromJson(Map<String, dynamic> json) {
  return Recipe(
    id: json['id'],
    name: json['name'],
    categoryId: json['categoryId'],
    coverImage: json['coverImage'],
    ingredients: (json['ingredients'] as List?)
        ?.map((i) => _ingredientFromJson(i))
        .toList() ?? [],
    steps: (json['steps'] as List?)
        ?.map((s) => _recipeStepFromJson(s))
        .toList() ?? [],
    cookCount: json['cookCount'] ?? 0,
    rating: (json['rating'] ?? 0.0).toDouble(),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    isFavorite: json['isFavorite'] ?? false,
    notes: json['notes'] ?? '',
  );
}
```

### 3. 数据验证

```dart
// 验证导入数据的完整性
bool _validateImportData(Map<String, dynamic> data) {
  // 检查版本兼容性
  if (data['version'] == null) {
    return false;
  }
  
  // 检查必要字段
  final requiredFields = ['categories', 'ingredients', 'recipes'];
  for (String field in requiredFields) {
    if (data[field] != null && data[field] is! List) {
      return false;
    }
  }
  
  // 验证菜谱数据结构
  if (data['recipes'] != null) {
    for (var recipe in data['recipes']) {
      if (!_validateRecipeData(recipe)) {
        return false;
      }
    }
  }
  
  return true;
}

bool _validateRecipeData(Map<String, dynamic> recipe) {
  final requiredFields = ['id', 'name', 'categoryId', 'createdAt', 'updatedAt'];
  
  for (String field in requiredFields) {
    if (recipe[field] == null) {
      return false;
    }
  }
  
  // 验证日期格式
  try {
    DateTime.parse(recipe['createdAt']);
    DateTime.parse(recipe['updatedAt']);
  } catch (e) {
    return false;
  }
  
  return true;
}
```

## 性能优化

### 1. 懒加载

```dart
// 懒加载大量数据
class LazyDataProvider extends ChangeNotifier {
  final Map<String, Recipe> _recipeCache = {};
  late Box<Recipe> _recipeBox;
  
  // 只在需要时加载菜谱
  Future<Recipe?> getRecipe(String id) async {
    // 先从缓存获取
    if (_recipeCache.containsKey(id)) {
      return _recipeCache[id];
    }
    
    // 从数据库加载
    final recipe = _recipeBox.get(id);
    if (recipe != null) {
      _recipeCache[id] = recipe;
    }
    
    return recipe;
  }
  
  // 清理缓存
  void clearCache() {
    _recipeCache.clear();
  }
}
```

### 2. 批量操作

```dart
// 批量插入数据
Future<void> batchInsertRecipes(List<Recipe> recipes) async {
  final Map<String, Recipe> recipeMap = {
    for (var recipe in recipes) recipe.id: recipe
  };
  
  // 使用 putAll 进行批量操作，比逐个 put 更高效
  await _recipeBox.putAll(recipeMap);
  
  _recipes.addAll(recipes);
  notifyListeners();
}

// 批量更新
Future<void> batchUpdateRecipes(List<Recipe> recipes) async {
  final Map<String, Recipe> updates = {};
  
  for (var recipe in recipes) {
    updates[recipe.id] = recipe;
    
    // 更新内存中的数据
    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _recipes[index] = recipe;
    }
  }
  
  await _recipeBox.putAll(updates);
  notifyListeners();
}
```

### 3. 索引优化

```dart
// 创建索引以提高查询性能
class IndexedDataProvider extends ChangeNotifier {
  // 按分类索引菜谱
  final Map<String, List<String>> _recipesByCategory = {};
  
  // 按名称索引菜谱（用于快速搜索）
  final Map<String, List<String>> _recipesByName = {};
  
  void _buildIndexes() {
    _recipesByCategory.clear();
    _recipesByName.clear();
    
    for (var recipe in _recipes) {
      // 分类索引
      _recipesByCategory.putIfAbsent(recipe.categoryId, () => []).add(recipe.id);
      
      // 名称索引（按首字母）
      final firstChar = recipe.name.isNotEmpty ? recipe.name[0].toUpperCase() : '#';
      _recipesByName.putIfAbsent(firstChar, () => []).add(recipe.id);
    }
  }
  
  // 使用索引快速查询
  List<Recipe> getRecipesByCategoryFast(String categoryId) {
    final recipeIds = _recipesByCategory[categoryId] ?? [];
    return recipeIds.map((id) => _recipes.firstWhere((r) => r.id == id)).toList();
  }
}
```

### 4. 内存管理

```dart
// 监控内存使用
class MemoryOptimizedProvider extends ChangeNotifier {
  static const int MAX_CACHE_SIZE = 100;
  final Map<String, Recipe> _recentlyAccessed = {};
  
  Recipe? getCachedRecipe(String id) {
    final recipe = _recentlyAccessed[id];
    
    if (recipe != null) {
      // 移到最后（LRU策略）
      _recentlyAccessed.remove(id);
      _recentlyAccessed[id] = recipe;
    }
    
    return recipe;
  }
  
  void cacheRecipe(Recipe recipe) {
    // 如果缓存已满，移除最旧的项
    if (_recentlyAccessed.length >= MAX_CACHE_SIZE) {
      final firstKey = _recentlyAccessed.keys.first;
      _recentlyAccessed.remove(firstKey);
    }
    
    _recentlyAccessed[recipe.id] = recipe;
  }
}
```

## 常见问题与解决方案

### 1. 适配器注册问题

**问题**: `HiveError: Cannot read, unknown typeId: X`

**原因**: 适配器未注册或 typeId 冲突

**解决方案**:
```dart
// 确保在使用前注册所有适配器
void _registerAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CategoryAdapter());
  }
  // ... 注册其他适配器
}

// 检查 typeId 是否唯一
// 每个模型的 typeId 必须不同
```

### 2. 数据迁移问题

**问题**: 添加新字段后旧数据无法读取

**解决方案**:
```dart
// 在适配器的 read 方法中处理向后兼容
@override
Recipe read(BinaryReader reader) {
  final numOfFields = reader.readByte();
  final fields = <int, dynamic>{
    for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
  };
  
  return Recipe(
    id: fields[0] as String,
    name: fields[1] as String,
    // 新字段提供默认值
    notes: fields[11] as String? ?? '', // 如果字段不存在，使用默认值
  );
}
```

### 3. 性能问题

**问题**: 大量数据时查询缓慢

**解决方案**:
```dart
// 1. 使用索引
// 2. 实现分页
// 3. 使用懒加载
// 4. 定期清理无用数据

// 分页示例
List<Recipe> getRecipesPage(int page, int size) {
  final start = page * size;
  final end = start + size;
  
  if (start >= _recipes.length) return [];
  
  return _recipes.sublist(start, math.min(end, _recipes.length));
}
```

### 4. 数据损坏问题

**问题**: 数据库文件损坏

**解决方案**:
```dart
// 实现数据恢复机制
Future<void> recoverData() async {
  try {
    // 尝试打开数据库
    await Hive.openBox<Recipe>('recipes');
  } catch (e) {
    // 如果失败，从备份恢复
    await _restoreFromBackup();
  }
}

// 定期备份
Future<void> createBackup() async {
  final data = await exportAllData();
  final backupPath = await _getBackupPath();
  await File(backupPath).writeAsString(jsonEncode(data));
}
```

### 5. 内存泄漏问题

**问题**: 长时间使用后内存占用过高

**解决方案**:
```dart
// 1. 及时关闭不用的 Box
@override
void dispose() {
  _recipeBox.close();
  _categoryBox.close();
  super.dispose();
}

// 2. 清理缓存
void clearCache() {
  _recipeCache.clear();
  _ingredientCache.clear();
}

// 3. 使用弱引用
final Map<String, WeakReference<Recipe>> _weakCache = {};
```

### 6. 并发访问问题

**问题**: 多个地方同时修改数据导致冲突

**解决方案**:
```dart
// 使用锁机制
final Mutex _mutex = Mutex();

Future<void> safeUpdateRecipe(Recipe recipe) async {
  await _mutex.acquire();
  try {
    await _recipeBox.put(recipe.id, recipe);
    // 更新内存数据
    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _recipes[index] = recipe;
    }
    notifyListeners();
  } finally {
    _mutex.release();
  }
}
```

## 最佳实践

### 1. 数据模型设计
- 保持模型简单，避免过度嵌套
- 为新字段提供默认值
- 使用有意义的 typeId 和字段索引

### 2. 性能优化
- 合理使用缓存
- 实现分页加载
- 定期清理无用数据
- 使用批量操作

### 3. 错误处理
- 实现数据备份机制
- 处理数据迁移
- 提供数据恢复功能

### 4. 内存管理
- 及时关闭不用的 Box
- 清理缓存数据
- 监控内存使用

### 5. 数据安全
- 定期备份重要数据
- 验证导入数据的完整性
- 实现数据加密（如需要）

这个手册涵盖了在灶边记项目中使用 Hive 数据库的所有重要方面。通过遵循这些指导原则和最佳实践，可以确保应用的数据管理既高效又可靠。