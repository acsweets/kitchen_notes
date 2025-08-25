import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../models/user_models.dart';
import '../network_config.dart';

class UserApi {
  final Dio _dio = DioClient.instance.dio;

  /// 获取用户信息
  Future<UserProfile> getUserProfile(int userId) async {
    final response = await _dio.get('/users/$userId');
    return UserProfile.fromJson(response.data);
  }

  /// 获取当前用户信息
  Future<UserProfile> getCurrentUserProfile() async {
    final response = await _dio.get('/users/profile');
    return UserProfile.fromJson(response.data);
  }

  /// 更新用户信息
  Future<UserProfile> updateUserProfile(UpdateProfileRequest request) async {
    final response = await _dio.put('/users/profile', data: request.toJson());
    return UserProfile.fromJson(response.data);
  }

  /// 关注用户
  Future<void> followUser(int userId) async {
    await _dio.post('/users/follow', data: {'userId': userId});
  }

  /// 取消关注
  Future<void> unfollowUser(int userId) async {
    await _dio.delete('/users/follow/$userId');
  }

  /// 获取粉丝列表
  Future<UserListResponse> getFollowers({
    required int userId,
    int page = 0,
    int size = NetworkConfig.defaultPageSize,
  }) async {
    final response = await _dio.get('/users/$userId/followers', queryParameters: {
      'page': page,
      'size': size,
    });
    return UserListResponse.fromJson(response.data);
  }

  /// 获取关注列表
  Future<UserListResponse> getFollowing({
    required int userId,
    int page = 0,
    int size = NetworkConfig.defaultPageSize,
  }) async {
    final response = await _dio.get('/users/$userId/following', queryParameters: {
      'page': page,
      'size': size,
    });
    return UserListResponse.fromJson(response.data);
  }

  /// 搜索用户
  Future<UserListResponse> searchUsers({
    required String keyword,
    int page = 0,
    int size = NetworkConfig.defaultPageSize,
  }) async {
    final response = await _dio.get('/users/search', queryParameters: {
      'keyword': keyword,
      'page': page,
      'size': size,
    });
    return UserListResponse.fromJson(response.data);
  }

  /// 检查是否关注某用户
  Future<bool> isFollowing(int userId) async {
    final response = await _dio.get('/users/$userId/is-following');
    return response.data['isFollowing'] ?? false;
  }

  /// 获取用户统计信息
  Future<UserStats> getUserStats(int userId) async {
    final response = await _dio.get('/users/$userId/stats');
    return UserStats.fromJson(response.data);
  }
}