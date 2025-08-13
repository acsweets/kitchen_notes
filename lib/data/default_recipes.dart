import 'package:uuid/uuid.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../models/recipe_step.dart';

class DefaultRecipes {
  static List<Recipe> getDefaultRecipes() {
    final uuid = Uuid();
    final now = DateTime.now();

    return [
      // 西红柿鸡蛋
      Recipe(
        id: uuid.v4(),
        name: '西红柿鸡蛋',
        categoryId: 'recipe_home',
        ingredients: [
          Ingredient(
            id: uuid.v4(),
            name: '西红柿',
            categoryId: 'ingredient_vegetable',
            quantity: 2,
            unit: '个',
          ),
          Ingredient(
            id: uuid.v4(),
            name: '鸡蛋',
            categoryId: 'ingredient_staple',
            quantity: 3,
            unit: '个',
          ),
          Ingredient(
            id: uuid.v4(),
            name: '盐',
            categoryId: 'ingredient_seasoning',
            quantity: 1,
            unit: '勺',
          ),
          Ingredient(
            id: uuid.v4(),
            name: '糖',
            categoryId: 'ingredient_seasoning',
            quantity: 0.5,
            unit: '勺',
          ),
        ],
        steps: [
          RecipeStep(
            order: 1,
            description: '西红柿洗净，用开水烫一下去皮，切成块状',
          ),
          RecipeStep(
            order: 2,
            description: '鸡蛋打散，加少许盐调味',
          ),
          RecipeStep(
            order: 3,
            description: '热锅下油，倒入蛋液炒熟盛起',
          ),
          RecipeStep(
            order: 4,
            description: '锅内留底油，下西红柿块炒出汁水',
          ),
          RecipeStep(
            order: 5,
            description: '加入炒蛋，调味炒匀即可',
          ),
        ],
        createdAt: now,
        updatedAt: now,
        notes: '经典家常菜，酸甜可口，营养丰富。可以根据个人喜好调整糖的用量。',
      ),

      // 土豆丝
      Recipe(
        id: uuid.v4(),
        name: '酸辣土豆丝',
        categoryId: 'recipe_home',
        ingredients: [
          Ingredient(
            id: uuid.v4(),
            name: '土豆',
            categoryId: 'ingredient_vegetable',
            quantity: 2,
            unit: '个',
          ),
          Ingredient(
            id: uuid.v4(),
            name: '青椒',
            categoryId: 'ingredient_vegetable',
            quantity: 1,
            unit: '个',
          ),
          Ingredient(
            id: uuid.v4(),
            name: '醋',
            categoryId: 'ingredient_seasoning',
            quantity: 2,
            unit: '勺',
          ),
          Ingredient(
            id: uuid.v4(),
            name: '辣椒',
            categoryId: 'ingredient_seasoning',
            quantity: 2,
            unit: '个',
          ),
        ],
        steps: [
          RecipeStep(
            order: 1,
            description: '土豆去皮切丝，用清水冲洗去淀粉',
          ),
          RecipeStep(
            order: 2,
            description: '青椒切丝，干辣椒切段',
          ),
          RecipeStep(
            order: 3,
            description: '热锅下油，爆香辣椒',
          ),
          RecipeStep(
            order: 4,
            description: '下土豆丝大火炒制',
          ),
          RecipeStep(
            order: 5,
            description: '加入青椒丝，调味炒匀即可',
          ),
        ],
        createdAt: now,
        updatedAt: now,
        notes: '爽脆酸辣，下饭神器。土豆丝要切得细一些，炒制时间不宜过长保持脆嫩。',
      ),

      // 蒸蛋羹
      Recipe(
        id: uuid.v4(),
        name: '水蒸蛋',
        categoryId: 'recipe_home',
        ingredients: [
          Ingredient(
            id: uuid.v4(),
            name: '鸡蛋',
            categoryId: 'ingredient_staple',
            quantity: 2,
            unit: '个',
          ),
          Ingredient(
            id: uuid.v4(),
            name: '温水',
            categoryId: 'ingredient_staple',
            quantity: 150,
            unit: '毫升',
          ),
          Ingredient(
            id: uuid.v4(),
            name: '盐',
            categoryId: 'ingredient_seasoning',
            quantity: 0.5,
            unit: '勺',
          ),
        ],
        steps: [
          RecipeStep(
            order: 1,
            description: '鸡蛋打散，加入温水和盐调匀',
          ),
          RecipeStep(
            order: 2,
            description: '过筛去除泡沫，倒入蒸碗',
          ),
          RecipeStep(
            order: 3,
            description: '盖上保鲜膜，用牙签扎几个小孔',
          ),
          RecipeStep(
            order: 4,
            description: '水开后蒸10-12分钟即可',
          ),
        ],
        createdAt: now,
        updatedAt: now,
        notes: '嫩滑如豆腐，老少皆宜。水和蛋的比例是关键，一般1:1.5最佳。',
      ),

      // 凉拌黄瓜
      Recipe(
        id: uuid.v4(),
        name: '凉拌黄瓜',
        categoryId: 'recipe_cold',
        ingredients: [
          Ingredient(
            id: uuid.v4(),
            name: '黄瓜',
            categoryId: 'ingredient_vegetable',
            quantity: 2,
            unit: '根',
          ),
          Ingredient(
            id: uuid.v4(),
            name: '蒜',
            categoryId: 'ingredient_vegetable',
            quantity: 3,
            unit: '瓣',
          ),
          Ingredient(
            id: uuid.v4(),
            name: '醋',
            categoryId: 'ingredient_seasoning',
            quantity: 2,
            unit: '勺',
          ),
          Ingredient(
            id: uuid.v4(),
            name: '香油',
            categoryId: 'ingredient_seasoning',
            quantity: 1,
            unit: '勺',
          ),
        ],
        steps: [
          RecipeStep(
            order: 1,
            description: '黄瓜洗净拍碎，切成段',
          ),
          RecipeStep(
            order: 2,
            description: '加盐腌制10分钟，挤出水分',
          ),
          RecipeStep(
            order: 3,
            description: '蒜切末，调入醋、香油等调料',
          ),
          RecipeStep(
            order: 4,
            description: '拌匀腌制15分钟即可',
          ),
        ],
        createdAt: now,
        updatedAt: now,
        notes: '清爽开胃，夏日必备。黄瓜要拍碎才更入味，腌制时间不要太长。',
      ),

      // 简单备注菜谱
      Recipe(
        id: uuid.v4(),
        name: '妈妈的红烧肉',
        categoryId: 'recipe_home',
        ingredients: [],
        steps: [],
        createdAt: now,
        updatedAt: now,
        notes: '五花肉切块，先焯水去腥。热锅下糖炒糖色，下肉块炒至上色。加生抽老抽料酒，倒入开水没过肉块。大火烧开转小火炖1小时，最后大火收汁即可。记住要用冰糖，这样颜色更亮。',
      ),
    ];
  }
}