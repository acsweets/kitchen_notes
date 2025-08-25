import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../models/category_models.dart';

class CategoryApi {
  final Dio _dio = DioClient.instance.dio;

  /// 获取用户类别列表
  Future<List<CategoryResponse>> getCategories() async {
    final response = await _dio.get('/categories');
    return (response.data as List)
        .map((item) => CategoryResponse.fromJson(item))
        .toList();
  }

  /// 创建新类别
  Future<CategoryResponse> createCategory(CreateCategoryRequest request) async {
    final response = await _dio.post('/categories', data: request.toJson());
    return CategoryResponse.fromJson(response.data);
  }

  /// 更新类别
  Future<CategoryResponse> updateCategory(int id, UpdateCategoryRequest request) async {
    final response = await _dio.put('/categories/$id', data: request.toJson());
    return CategoryResponse.fromJson(response.data);
  }

  /// 删除类别
  Future<void> deleteCategory(int id) async {
    await _dio.delete('/categories/$id');
  }
}