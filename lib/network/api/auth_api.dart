import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../models/auth_models.dart';


class AuthApi {
  final Dio _dio = DioClient.instance.dio;

  /// 用户注册
  Future<void> register(RegisterRequest request) async {
    await _dio.post('/auth/register', data: request.toJson());
  }

  /// 用户登录
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post('/auth/login', data: request.toJson());
    return LoginResponse.fromJson(response.data);
  }

  /// 刷新Token
  Future<LoginResponse> refreshToken(String refreshToken) async {
    final response = await _dio.post('/auth/refresh', data: {
      'refreshToken': refreshToken,
    });
    return LoginResponse.fromJson(response.data);
  }

  /// 登出
  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }

  /// 修改密码
  Future<void> changePassword(ChangePasswordRequest request) async {
    await _dio.post('/auth/change-password', data: request.toJson());
  }

  /// 忘记密码
  Future<void> forgotPassword(String email) async {
    await _dio.post('/auth/forgot-password', data: {
      'email': email,
    });
  }

  /// 重置密码
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _dio.post('/auth/reset-password', data: request.toJson());
  }
}