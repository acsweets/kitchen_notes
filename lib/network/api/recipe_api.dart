import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../models/recipe_models.dart';
import '../network_config.dart';

class RecipeApi {
  final Dio _dio = DioClient.instance.dio;

  /// 获取菜谱列表
  Future<RecipeListResponse> getRecipes({
    int page = 0,
    int size = NetworkConfig.defaultPageSize,
  }) async {
    final response = await _dio.get('/recipes', queryParameters: {
      'page': page,
      'size': size,
    });
    return RecipeListResponse.fromJson(response.data);
  }

  /// 获取菜谱详情
  Future<RecipeDetailResponse> getRecipeDetail(int id) async {
    final response = await _dio.get('/recipes/$id');
    return RecipeDetailResponse.fromJson(response.data);
  }

  /// 创建菜谱
  Future<RecipeDetailResponse> createRecipe(CreateRecipeRequest request) async {
    final response = await _dio.post('/recipes', data: request.toJson());
    return RecipeDetailResponse.fromJson(response.data);
  }

  /// 更新菜谱
  Future<RecipeDetailResponse> updateRecipe(int id, UpdateRecipeRequest request) async {
    final response = await _dio.put('/recipes/$id', data: request.toJson());
    return RecipeDetailResponse.fromJson(response.data);
  }

  /// 删除菜谱
  Future<void> deleteRecipe(int id) async {
    await _dio.delete('/recipes/$id');
  }

  /// 搜索菜谱
  Future<RecipeListResponse> searchRecipes({
    required String keyword,
    int page = 0,
    int size = NetworkConfig.defaultPageSize,
  }) async {
    final response = await _dio.get('/recipes/search', queryParameters: {
      'keyword': keyword,
      'page': page,
      'size': size,
    });
    return RecipeListResponse.fromJson(response.data);
  }

  /// 获取热门菜谱
  Future<List<RecipeSummary>> getTrendingRecipes({int limit = 10}) async {
    final response = await _dio.get('/recipes/trending', queryParameters: {
      'limit': limit,
    });
    return (response.data as List)
        .map((item) => RecipeSummary.fromJson(item))
        .toList();
  }

  /// 点赞菜谱
  Future<void> likeRecipe(int id) async {
    await _dio.post('/recipes/$id/like');
  }

  /// 取消点赞
  Future<void> unlikeRecipe(int id) async {
    await _dio.delete('/recipes/$id/like');
  }

  /// 收藏菜谱
  Future<void> collectRecipe(int id) async {
    await _dio.post('/recipes/$id/collect');
  }

  /// 取消收藏
  Future<void> uncollectRecipe(int id) async {
    await _dio.delete('/recipes/$id/collect');
  }

  /// 获取用户的菜谱
  Future<RecipeListResponse> getUserRecipes({
    int? userId,
    int page = 0,
    int size = NetworkConfig.defaultPageSize,
  }) async {
    final path = userId != null ? '/users/$userId/recipes' : '/recipes/my';
    final response = await _dio.get(path, queryParameters: {
      'page': page,
      'size': size,
    });
    return RecipeListResponse.fromJson(response.data);
  }

  /// 获取收藏的菜谱
  Future<RecipeListResponse> getCollectedRecipes({
    int page = 0,
    int size = NetworkConfig.defaultPageSize,
  }) async {
    final response = await _dio.get('/recipes/collected', queryParameters: {
      'page': page,
      'size': size,
    });
    return RecipeListResponse.fromJson(response.data);
  }

  /// 按类别获取菜谱
  Future<RecipeListResponse> getRecipesByCategory({
    required int categoryId,
    int page = 0,
    int size = NetworkConfig.defaultPageSize,
  }) async {
    final response = await _dio.get('/recipes', queryParameters: {
      'categoryId': categoryId,
      'page': page,
      'size': size,
    });
    return RecipeListResponse.fromJson(response.data);
  }
}