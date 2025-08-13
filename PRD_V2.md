# 灶边记 2.0 - 产品需求文档 (PRD)

## 版本历史
- V1.0: 基础菜谱管理、食材管理、做菜日历
- V2.0: 社区功能、智能推荐、图片增强

## 1. 产品概述

### 1.1 产品定位升级
从本地菜谱管理工具升级为**社区化智能厨房助手**，在保持本地存储优势的基础上，增加社区分享和智能推荐功能。

### 1.2 核心价值升级
- 快速记录和查找菜谱
- **社区分享与发现优质菜谱**
- **基于现有食材的智能推荐**
- **丰富的图片展示体验**
- 本地存储，支持离线使用

### 1.3 目标用户扩展
- 经常在家做饭的用户
- 需要管理菜谱和食材的家庭主厨
- **喜欢分享烹饪经验的美食爱好者**
- **寻找新菜谱灵感的用户**
- **希望减少食材浪费的环保用户**

## 2. V2.0 新增功能规划

### 2.1 社区功能模块 🆕

#### 2.1.1 核心功能
| 功能 | 描述 | 优先级 |
|------|------|--------|
| 菜谱分享 | 用户可以将自己的菜谱分享到社区 | P0 |
| 菜谱浏览 | 浏览社区中其他用户分享的菜谱 | P0 |
| 一键收藏 | 一键添加别人的菜谱到自己的收藏 | P0 |
| 用户系统 | 简单的用户注册、登录、个人主页 | P0 |
| 菜谱搜索 | 在社区中搜索菜谱 | P1 |

#### 2.1.2 增强功能
| 功能 | 描述 | 优先级 |
|------|------|--------|
| 点赞评论 | 对菜谱进行点赞和评论 | P1 |
| 关注系统 | 关注喜欢的用户，查看其分享 | P1 |
| 标签系统 | 为菜谱添加标签，便于分类和搜索 | P1 |
| 热门推荐 | 基于点赞数、收藏数推荐热门菜谱 | P2 |
| 举报机制 | 举报不当内容，维护社区环境 | P2 |

### 2.2 图片功能增强 🆕

#### 2.2.1 核心功能
| 功能 | 描述 | 优先级 |
|------|------|--------|
| 菜谱封面图 | 为菜谱添加精美封面图片 | P0 |
| 步骤配图 | 每个制作步骤可添加多张图片 | P0 |
| 成品展示 | 制作完成后拍照展示成品 | P0 |
| 图片压缩 | 自动压缩图片，节省存储空间 | P1 |
| 图片编辑 | 简单的裁剪、滤镜功能 | P1 |

#### 2.2.2 增强功能
| 功能 | 描述 | 优先级 |
|------|------|--------|
| 图片云存储 | 图片上传到云端，支持多设备同步 | P1 |
| 图片识别 | AI识别食材和菜品，自动填充信息 | P2 |
| 图片水印 | 为分享的图片添加用户水印 | P2 |

### 2.3 智能推荐系统 🆕

#### 2.3.1 核心功能
| 功能 | 描述 | 优先级 |
|------|------|--------|
| 食材匹配推荐 | 根据现有食材推荐可制作的菜谱 | P0 |
| 缺失食材提示 | 显示制作菜谱还需要哪些食材 | P0 |
| 即将过期提醒 | 推荐使用即将过期食材的菜谱 | P0 |
| 购物清单生成 | 根据想做的菜谱生成购物清单 | P1 |

#### 2.3.2 增强功能
| 功能 | 描述 | 优先级 |
|------|------|--------|
| 个性化推荐 | 基于用户喜好和历史记录推荐 | P1 |
| 营养搭配建议 | 根据营养需求推荐菜谱组合 | P2 |
| 季节性推荐 | 根据季节推荐时令菜谱 | P2 |
| 难度匹配 | 根据用户技能水平推荐合适难度的菜谱 | P2 |

## 3. 用户界面设计升级

### 3.1 新增页面结构

#### 3.1.1 社区首页
- 热门菜谱轮播图
- 分类导航（家常菜、烘焙、素食等）
- 菜谱瀑布流展示
- 搜索框和筛选功能
- 底部导航：首页、发现、发布、消息、我的

#### 3.1.2 菜谱详情页升级
- 高清封面图片轮播
- 作者信息和关注按钮
- 点赞、收藏、分享按钮
- 制作步骤图文并茂
- 用户评论区
- 相关推荐菜谱

#### 3.1.3 发布菜谱页面
- 拖拽上传多张图片
- 图片编辑和排序
- 富文本编辑器
- 标签选择器
- 隐私设置（公开/私密）

#### 3.1.4 智能推荐页面
- 基于现有食材的推荐
- 即将过期食材提醒
- 缺失食材购物清单
- 个性化推荐区域

#### 3.1.5 个人主页
- 用户头像和简介
- 发布的菜谱网格展示
- 收藏的菜谱
- 粉丝和关注数
- 成就徽章展示

### 3.2 现有页面升级

#### 3.2.1 首页升级
- 添加智能推荐模块
- 社区热门菜谱推荐
- 基于食材的今日推荐

#### 3.2.2 食材管理页升级
- 添加"推荐菜谱"按钮
- 即将过期食材突出显示
- 购物清单快速生成

## 4. 技术架构升级

### 4.1 新增技术栈
- **后端服务**: Node.js + Express + MongoDB
- **图片存储**: 阿里云OSS / AWS S3
- **推送服务**: Firebase Cloud Messaging
- **图片处理**: ImageMagick / Sharp
- **AI服务**: 百度AI / 腾讯云AI

### 4.2 数据模型扩展

#### 4.2.1 用户模型 🆕
```dart
class User {
  String id;
  String username;
  String email;
  String? avatar;
  String? bio;
  DateTime createdAt;
  int followersCount;
  int followingCount;
  int recipesCount;
  List<String> achievements;
}
```

#### 4.2.2 菜谱模型升级
```dart
class Recipe {
  // 原有字段...
  
  // 新增字段
  String? authorId;           // 作者ID
  List<String> images;        // 多张图片
  List<String> tags;          // 标签
  int likesCount;             // 点赞数
  int collectionsCount;       // 收藏数
  bool isPublic;              // 是否公开
  String difficulty;          // 难度等级
  int prepTime;               // 准备时间
  int cookTime;               // 烹饪时间
  int servings;               // 份数
  Map<String, double> nutrition; // 营养信息
}
```

#### 4.2.3 推荐记录模型 🆕
```dart
class Recommendation {
  String id;
  String userId;
  String recipeId;
  String type;                // 推荐类型
  double score;               // 推荐分数
  Map<String, dynamic> reason; // 推荐原因
  DateTime createdAt;
  bool isClicked;             // 是否被点击
}
```

#### 4.2.4 社交互动模型 🆕
```dart
class Like {
  String id;
  String userId;
  String recipeId;
  DateTime createdAt;
}

class Comment {
  String id;
  String userId;
  String recipeId;
  String content;
  DateTime createdAt;
  List<String> images;        // 评论图片
}

class Follow {
  String id;
  String followerId;          // 关注者
  String followingId;         // 被关注者
  DateTime createdAt;
}
```

### 4.3 推荐算法设计

#### 4.3.1 食材匹配算法
```dart
class IngredientMatcher {
  // 计算菜谱与现有食材的匹配度
  double calculateMatchScore(Recipe recipe, List<Ingredient> availableIngredients) {
    int totalIngredients = recipe.ingredients.length;
    int matchedIngredients = 0;
    
    for (var recipeIngredient in recipe.ingredients) {
      if (availableIngredients.any((available) => 
          available.name.toLowerCase() == recipeIngredient.name.toLowerCase())) {
        matchedIngredients++;
      }
    }
    
    return matchedIngredients / totalIngredients;
  }
  
  // 获取推荐菜谱
  List<Recipe> getRecommendedRecipes(List<Ingredient> availableIngredients) {
    return allRecipes
        .map((recipe) => {
          'recipe': recipe,
          'score': calculateMatchScore(recipe, availableIngredients)
        })
        .where((item) => item['score'] > 0.5) // 至少匹配50%食材
        .toList()
        ..sort((a, b) => b['score'].compareTo(a['score']))
        .map((item) => item['recipe'] as Recipe)
        .take(10)
        .toList();
  }
}
```

#### 4.3.2 个性化推荐算法
```dart
class PersonalizedRecommender {
  // 基于用户行为的推荐
  List<Recipe> getPersonalizedRecommendations(String userId) {
    final userHistory = getUserCookingHistory(userId);
    final userPreferences = analyzeUserPreferences(userHistory);
    
    return findSimilarRecipes(userPreferences)
        .where((recipe) => !userHistory.contains(recipe.id))
        .take(20)
        .toList();
  }
  
  // 分析用户偏好
  UserPreferences analyzeUserPreferences(List<CookingRecord> history) {
    // 分析用户常做的菜系、口味、难度等
    return UserPreferences(
      favoriteCategories: extractFavoriteCategories(history),
      averageCookTime: calculateAverageCookTime(history),
      skillLevel: assessSkillLevel(history),
    );
  }
}
```

## 5. API 设计

### 5.1 用户相关API
```
POST /api/auth/register     # 用户注册
POST /api/auth/login        # 用户登录
GET  /api/users/profile     # 获取用户信息
PUT  /api/users/profile     # 更新用户信息
POST /api/users/follow      # 关注用户
DELETE /api/users/follow    # 取消关注
```

### 5.2 菜谱相关API
```
GET  /api/recipes           # 获取菜谱列表
POST /api/recipes           # 发布菜谱
GET  /api/recipes/:id       # 获取菜谱详情
PUT  /api/recipes/:id       # 更新菜谱
DELETE /api/recipes/:id     # 删除菜谱
POST /api/recipes/:id/like  # 点赞菜谱
POST /api/recipes/:id/collect # 收藏菜谱
```

### 5.3 推荐相关API
```
GET  /api/recommendations/ingredients  # 基于食材推荐
GET  /api/recommendations/personal     # 个性化推荐
GET  /api/recommendations/trending     # 热门推荐
POST /api/recommendations/feedback     # 推荐反馈
```

### 5.4 图片相关API
```
POST /api/upload/image      # 上传图片
GET  /api/images/:id        # 获取图片
DELETE /api/images/:id      # 删除图片
POST /api/images/compress   # 压缩图片
```

## 6. 开发计划

### 6.1 第一阶段 (2个月)
- [ ] 用户系统开发
- [ ] 图片上传和管理
- [ ] 基础社区功能
- [ ] 菜谱分享功能

### 6.2 第二阶段 (2个月)
- [ ] 智能推荐系统
- [ ] 食材匹配算法
- [ ] 社交互动功能
- [ ] 个人主页完善

### 6.3 第三阶段 (1个月)
- [ ] 性能优化
- [ ] UI/UX优化
- [ ] 测试和修复
- [ ] 上线准备

## 7. 数据安全与隐私

### 7.1 数据保护
- 用户数据加密存储
- 图片访问权限控制
- 敏感信息脱敏处理

### 7.2 隐私设置
- 菜谱公开/私密设置
- 个人信息可见性控制
- 数据导出和删除权限

### 7.3 内容审核
- 图片内容自动审核
- 文本内容关键词过滤
- 用户举报处理机制

## 8. 商业模式探索

### 8.1 增值服务
- 高级用户功能（更多存储空间、高级推荐）
- 营养分析报告
- 个性化菜谱定制

### 8.2 合作机会
- 食材供应商合作
- 厨具品牌推广
- 美食博主入驻

### 8.3 广告模式
- 原生广告植入
- 品牌菜谱推广
- 精准用户投放

## 9. 成功指标

### 9.1 用户增长指标
- 日活跃用户数 (DAU)
- 月活跃用户数 (MAU)
- 用户留存率
- 新用户注册转化率

### 9.2 内容指标
- 菜谱发布数量
- 图片上传数量
- 用户互动数（点赞、评论、分享）
- 菜谱收藏率

### 9.3 推荐效果指标
- 推荐点击率
- 推荐菜谱制作率
- 食材利用率提升
- 用户满意度评分

## 10. 风险评估与应对

### 10.1 技术风险
- **服务器负载**: 采用云服务自动扩容
- **图片存储成本**: 实施图片压缩和CDN优化
- **推荐算法准确性**: 持续优化和A/B测试

### 10.2 内容风险
- **版权问题**: 建立原创保护机制
- **不当内容**: 完善审核和举报系统
- **用户隐私**: 严格遵守数据保护法规

### 10.3 竞争风险
- **差异化定位**: 专注本地化和智能推荐
- **用户粘性**: 建立完善的社区生态
- **技术壁垒**: 持续创新和功能迭代

## 11. 总结

灶边记 2.0 将从单纯的菜谱管理工具升级为智能化的社区厨房助手。通过引入社区功能、图片增强和智能推荐，为用户提供更丰富的使用体验和价值。

**核心竞争优势**：
1. **本地+云端**的混合存储模式
2. **基于食材的智能推荐**算法
3. **图文并茂**的优质内容生态
4. **简单易用**的社区分享体验

**预期效果**：
- 用户活跃度提升 200%
- 菜谱制作成功率提升 150%
- 食材浪费减少 30%
- 用户满意度达到 4.5/5.0