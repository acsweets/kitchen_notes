# 数据文件说明

本目录包含应用的默认数据，以 JSON 格式存储，便于维护和扩展。

## 文件结构

### categories.json
包含菜谱分类和食材分类的定义。

```json
{
  "recipe_categories": [
    {
      "id": "分类ID",
      "name": "分类名称",
      "type": "recipe",
      "isDefault": true
    }
  ],
  "ingredient_categories": [
    {
      "id": "分类ID", 
      "name": "分类名称",
      "type": "ingredient",
      "isDefault": true
    }
  ]
}
```

### ingredients.json
包含默认食材数据，按类别分组。

```json
{
  "vegetables": [
    {
      "id": "食材ID",
      "name": "食材名称",
      "categoryId": "所属分类ID",
      "quantity": 0,
      "unit": "单位"
    }
  ],
  "meat": [...],
  "seasonings": [...],
  "staples": [...]
}
```

### recipes.json
包含默认菜谱数据。

```json
{
  "recipes": [
    {
      "name": "菜谱名称",
      "categoryId": "所属分类ID",
      "ingredients": [
        {
          "name": "食材名称",
          "categoryId": "食材分类ID",
          "quantity": 数量,
          "unit": "单位"
        }
      ],
      "steps": [
        {
          "order": 步骤序号,
          "description": "步骤描述"
        }
      ],
      "notes": "备注信息"
    }
  ]
}
```

## 使用方式

数据通过 `JsonDataLoader` 类加载：

```dart
// 加载分类
final categories = await JsonDataLoader.loadCategories();

// 加载食材
final ingredients = await JsonDataLoader.loadIngredients();

// 加载菜谱
final recipes = await JsonDataLoader.loadRecipes();
```

## 扩展数据

要添加新的默认数据，只需编辑对应的 JSON 文件即可，无需修改 Dart 代码。

### 添加新分类
在 `categories.json` 的对应数组中添加新项目。

### 添加新食材
在 `ingredients.json` 的对应分类数组中添加新项目。

### 添加新菜谱
在 `recipes.json` 的 `recipes` 数组中添加新项目。

## 注意事项

1. ID 必须唯一
2. categoryId 必须对应已存在的分类
3. JSON 格式必须正确
4. 修改后需要重新构建应用