import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/recipe_step.dart';
import '../models/cooking_record.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'kitchen_notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 创建分类表
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // 创建食材表
    await db.execute('''
      CREATE TABLE ingredients (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category_id TEXT NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT NOT NULL,
        expiry_date INTEGER,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    // 创建菜谱表
    await db.execute('''
      CREATE TABLE recipes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category_id TEXT NOT NULL,
        cover_image TEXT,
        cook_count INTEGER NOT NULL DEFAULT 0,
        rating REAL NOT NULL DEFAULT 0.0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        notes TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    // 创建菜谱食材表
    await db.execute('''
      CREATE TABLE recipe_ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipe_id TEXT NOT NULL,
        name TEXT NOT NULL,
        category_id TEXT NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT NOT NULL,
        FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
      )
    ''');

    // 创建菜谱步骤表
    await db.execute('''
      CREATE TABLE recipe_steps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipe_id TEXT NOT NULL,
        step_order INTEGER NOT NULL,
        description TEXT NOT NULL,
        images TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
      )
    ''');

    // 创建制作记录表
    await db.execute('''
      CREATE TABLE cooking_records (
        id TEXT PRIMARY KEY,
        recipe_id TEXT NOT NULL,
        recipe_name TEXT NOT NULL,
        cooking_date INTEGER NOT NULL,
        rating REAL NOT NULL,
        notes TEXT NOT NULL DEFAULT '',
        images TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (recipe_id) REFERENCES recipes (id)
      )
    ''');
  }

  // 分类相关操作
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(String id) async {
    final db = await database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // 食材相关操作
  Future<int> insertIngredient(Ingredient ingredient) async {
    final db = await database;
    return await db.insert('ingredients', ingredient.toMap());
  }

  Future<List<Ingredient>> getIngredients() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ingredients');
    return List.generate(maps.length, (i) => Ingredient.fromMap(maps[i]));
  }

  Future<int> updateIngredient(Ingredient ingredient) async {
    final db = await database;
    return await db.update(
      'ingredients',
      ingredient.toMap(),
      where: 'id = ?',
      whereArgs: [ingredient.id],
    );
  }

  Future<int> deleteIngredient(String id) async {
    final db = await database;
    return await db.delete('ingredients', where: 'id = ?', whereArgs: [id]);
  }

  // 菜谱相关操作
  Future<int> insertRecipe(Recipe recipe) async {
    final db = await database;
    await db.transaction((txn) async {
      // 插入菜谱基本信息
      await txn.insert('recipes', recipe.toMap());
      
      // 插入菜谱食材
      for (var ingredient in recipe.ingredients) {
        await txn.insert('recipe_ingredients', {
          'recipe_id': recipe.id,
          'name': ingredient.name,
          'category_id': ingredient.categoryId,
          'quantity': ingredient.quantity,
          'unit': ingredient.unit,
        });
      }
      
      // 插入菜谱步骤
      for (var step in recipe.steps) {
        await txn.insert('recipe_steps', {
          'recipe_id': recipe.id,
          'step_order': step.order,
          'description': step.description,
          'images': step.images.join(','),
        });
      }
    });
    return 1;
  }

  Future<List<Recipe>> getRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> recipeMaps = await db.query('recipes');
    
    List<Recipe> recipes = [];
    for (var recipeMap in recipeMaps) {
      // 获取菜谱食材
      final ingredientMaps = await db.query(
        'recipe_ingredients',
        where: 'recipe_id = ?',
        whereArgs: [recipeMap['id']],
      );
      
      List<Ingredient> ingredients = ingredientMaps.map((map) => Ingredient(
        id: '',
        name: map['name'] as String,
        categoryId: map['category_id'] as String,
        quantity: (map['quantity'] as num).toDouble(),
        unit: map['unit'] as String,
      )).toList();
      
      // 获取菜谱步骤
      final stepMaps = await db.query(
        'recipe_steps',
        where: 'recipe_id = ?',
        whereArgs: [recipeMap['id']],
        orderBy: 'step_order ASC',
      );
      
      List<RecipeStep> steps = stepMaps.map((map) => RecipeStep(
        order: map['step_order'] as int,
        description: map['description'] as String,
        images: (map['images'] as String).isEmpty 
            ? [] 
            : (map['images'] as String).split(','),
      )).toList();
      
      recipes.add(Recipe.fromMap(recipeMap, ingredients, steps));
    }
    
    return recipes;
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final db = await database;
    return await db.transaction((txn) async {
      // 更新菜谱基本信息
      await txn.update(
        'recipes',
        recipe.toMap(),
        where: 'id = ?',
        whereArgs: [recipe.id],
      );
      
      // 删除旧的食材和步骤
      await txn.delete('recipe_ingredients', where: 'recipe_id = ?', whereArgs: [recipe.id]);
      await txn.delete('recipe_steps', where: 'recipe_id = ?', whereArgs: [recipe.id]);
      
      // 插入新的食材
      for (var ingredient in recipe.ingredients) {
        await txn.insert('recipe_ingredients', {
          'recipe_id': recipe.id,
          'name': ingredient.name,
          'category_id': ingredient.categoryId,
          'quantity': ingredient.quantity,
          'unit': ingredient.unit,
        });
      }
      
      // 插入新的步骤
      for (var step in recipe.steps) {
        await txn.insert('recipe_steps', {
          'recipe_id': recipe.id,
          'step_order': step.order,
          'description': step.description,
          'images': step.images.join(','),
        });
      }
      
      return 1;
    });
  }

  Future<int> deleteRecipe(String id) async {
    final db = await database;
    return await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }

  // 制作记录相关操作
  Future<int> insertCookingRecord(CookingRecord record) async {
    final db = await database;
    return await db.insert('cooking_records', record.toMap());
  }

  Future<List<CookingRecord>> getCookingRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cooking_records');
    return List.generate(maps.length, (i) => CookingRecord.fromMap(maps[i]));
  }

  Future<int> updateCookingRecord(CookingRecord record) async {
    final db = await database;
    return await db.update(
      'cooking_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteCookingRecord(String id) async {
    final db = await database;
    return await db.delete('cooking_records', where: 'id = ?', whereArgs: [id]);
  }
}