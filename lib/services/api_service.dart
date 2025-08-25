import '../network/api_client.dart';
import '../network/models/recipe_models.dart';
import '../network/models/user_models.dart';
import '../network/models/upload_models.dart';
import '../network/models/category_models.dart';
import 'dart:io';

/// API服务 - 使用Dio和模块化设计
class ApiService {
  static final ApiClient _client = ApiClient.instance;

  // === 菜谱相关 ===
  
  /// 获取菜谱列表
  static Future<RecipeListResponse> getRecipes({int page = 0, int size = 10}) async {
    return await _client.recipe.getRecipes(page: page, size: size);
  }

  /// 获取菜谱详情
  static Future<RecipeDetailResponse> getRecipeDetail(int id) async {
    return await _client.recipe.getRecipeDetail(id);
  }

  /// 搜索菜谱
  static Future<RecipeListResponse> searchRecipes(String keyword, {int page = 0, int size = 10}) async {
    return await _client.recipe.searchRecipes(keyword: keyword, page: page, size: size);
  }

  /// 获取热门菜谱
  static Future<List<RecipeSummary>> getTrendingRecipes({int limit = 10}) async {
    return await _client.recipe.getTrendingRecipes(limit: limit);
  }

  /// 点赞菜谱
  static Future<void> likeRecipe(int id) async {
    await _client.recipe.likeRecipe(id);
  }

  /// 收藏菜谱
  static Future<void> collectRecipe(int id) async {
    await _client.recipe.collectRecipe(id);
  }

  /// 创建菜谱
  static Future<RecipeDetailResponse> createRecipe(CreateRecipeRequest request) async {
    return await _client.recipe.createRecipe(request);
  }

  /// 按类别获取菜谱
  static Future<RecipeListResponse> getRecipesByCategory(int categoryId, {int page = 0, int size = 10}) async {
    return await _client.recipe.getRecipesByCategory(categoryId: categoryId, page: page, size: size);
  }

  // === 类别相关 ===

  /// 获取类别列表
  static Future<List<CategoryResponse>> getCategories() async {
    return await _client.category.getCategories();
  }

  /// 创建类别
  static Future<CategoryResponse> createCategory(CreateCategoryRequest request) async {
    return await _client.category.createCategory(request);
  }

  /// 更新类别
  static Future<CategoryResponse> updateCategory(int id, UpdateCategoryRequest request) async {
    return await _client.category.updateCategory(id, request);
  }

  /// 删除类别
  static Future<void> deleteCategory(int id) async {
    await _client.category.deleteCategory(id);
  }

  // === 用户相关 ===

  /// 获取用户信息
  static Future<UserProfile> getUserProfile(int userId) async {
    return await _client.user.getUserProfile(userId);
  }

  /// 获取当前用户信息
  static Future<UserProfile> getCurrentUserProfile() async {
    return await _client.user.getCurrentUserProfile();
  }

  /// 更新用户信息
  static Future<UserProfile> updateUserProfile(UpdateProfileRequest request) async {
    return await _client.user.updateUserProfile(request);
  }

  /// 关注用户
  static Future<void> followUser(int userId) async {
    await _client.user.followUser(userId);
  }

  // === 上传相关 ===

  /// 上传图片
  static Future<ImageUploadResponse> uploadImage(File imageFile) async {
    return await _client.upload.uploadImage(imageFile);
  }

  /// 批量上传图片
  static Future<List<ImageUploadResponse>> uploadImages(List<File> imageFiles) async {
    return await _client.upload.uploadImages(imageFiles);
  }

  /// 上传头像
  static Future<ImageUploadResponse> uploadAvatar(File avatarFile) async {
    return await _client.upload.uploadAvatar(avatarFile);
  }

  /// 删除图片
  static Future<void> deleteImage(String imageId) async {
    await _client.upload.deleteImage(imageId);
  }
}