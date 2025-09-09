# SQLite 数据库迁移说明

## 迁移概述

本项目已从 Hive 数据库成功迁移到 SQLite 数据库。这次迁移提供了更好的数据管理、查询性能和跨平台兼容性。

## 主要变更

### 1. 依赖包变更
- **移除**: `hive: ^2.2.3`, `hive_flutter: ^1.1.0`, `hive_generator: ^2.0.1`, `build_runner: ^2.4.9`
- **新增**: `sqflite: ^2.4.1`

### 2. 数据模型变更
所有数据模型类已移除 Hive 注解，新增 SQLite 支持方法：

#### 变更前 (Hive)
```dart
@HiveType(typeId: 0)
class Category {
  @HiveField(0)
  String id;
  // ...
}
```

#### 变更后 (SQLite)
```dart
class Category {
  String id;
  // ...
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      // ...
    };
  }
  
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      // ...
    );
  }
}
```

### 3. 数据库结构

#### 数据表设计
1. **categories** - 分类表
2. **ingredients** - 食材表
3. **recipes** - 菜谱表
4. **recipe_ingredients** - 菜谱食材关联表
5. **recipe_steps** - 菜谱步骤表
6. **cooking_records** - 制作记录表

#### 外键关系
- `ingredients.category_id` → `categories.id`
- `recipes.category_id` → `categories.id`
- `recipe_ingredients.recipe_id` → `recipes.id`
- `recipe_steps.recipe_id` → `recipes.id`
- `cooking_records.recipe_id` → `recipes.id`

### 4. 数据访问层变更

#### 新增 DatabaseHelper 类
- 位置: `lib/database/database_helper.dart`
- 功能: 统一管理所有数据库操作
- 支持事务处理，确保数据一致性

#### DataProvider 更新
- 移除 Hive Box 依赖
- 使用 DatabaseHelper 进行数据操作
- 保持相同的公共 API，确保 UI 层无需修改

## 迁移优势

### 1. 性能提升
- **查询优化**: SQLite 支持复杂查询和索引
- **事务支持**: 确保数据一致性
- **内存效率**: 按需加载数据

### 2. 数据完整性
- **外键约束**: 确保数据关系完整性
- **类型安全**: 强类型字段定义
- **级联删除**: 自动清理关联数据

### 3. 维护性
- **标准 SQL**: 使用标准 SQL 语法
- **调试友好**: 可使用 SQL 工具查看数据
- **备份简单**: 单文件数据库易于备份

### 4. 扩展性
- **复杂查询**: 支持 JOIN、聚合等复杂操作
- **全文搜索**: 可扩展 FTS 功能
- **数据分析**: 便于统计和分析

## 数据迁移

### 自动迁移
应用首次启动时会自动：
1. 创建 SQLite 数据库和表结构
2. 检查并插入默认数据
3. 保持现有功能完全兼容

### 手动重置
如需重置到默认数据，可调用：
```dart
await dataProvider.resetToDefaults();
```

## 注意事项

### 1. 兼容性
- 最低 Flutter SDK: 3.6.2+
- 支持所有平台: iOS, Android, macOS, Windows, Linux, Web

### 2. 数据存储
- 数据库文件: `kitchen_notes.db`
- 位置: 应用数据目录
- 自动创建和管理

### 3. 性能建议
- 大批量操作使用事务
- 适当使用索引优化查询
- 定期清理无用数据

## 开发指南

### 添加新表
1. 在 `DatabaseHelper._onCreate` 中添加 CREATE TABLE 语句
2. 增加对应的 CRUD 方法
3. 更新数据模型的 `toMap` 和 `fromMap` 方法

### 数据库版本升级
```dart
Future<Database> _initDatabase() async {
  return await openDatabase(
    path,
    version: 2, // 增加版本号
    onCreate: _onCreate,
    onUpgrade: _onUpgrade, // 添加升级逻辑
  );
}
```

### 调试数据库
可使用 SQLite 浏览器工具查看数据库文件，便于调试和数据分析。

## 总结

SQLite 迁移为项目带来了更好的性能、数据完整性和扩展性。所有现有功能保持不变，用户体验无影响，同时为未来功能扩展奠定了坚实基础。