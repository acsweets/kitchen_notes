import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../network/models/auth_models.dart';


/// 认证服务 - 使用Dio网络框架
class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';

  static bool _isLoggedIn = false;
  static int? _currentUserId;
  static String? _currentUsername;
  static String? _currentEmail;
  static String? _token;

  /// 初始化认证状态
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    
    if (token != null) {
      _token = token;
      _isLoggedIn = true;
      _currentUserId = prefs.getInt(_userIdKey);
      _currentUsername = prefs.getString(_usernameKey);
      _currentEmail = prefs.getString(_emailKey);
    }
  }

  /// 用户注册
  static Future<void> register(String username, String email, String password) async {
    final request = RegisterRequest(
      username: username,
      email: email,
      password: password,
    );
    await ApiClient.instance.auth.register(request);
  }

  /// 用户登录
  static Future<LoginResponse> login(String username, String password) async {
    final request = LoginRequest(username: username, password: password);
    final response = await ApiClient.instance.auth.login(request);
    
    // 保存登录信息
    await _saveAuthData(response);
    
    return response;
  }

  /// 用户登出
  static Future<void> logout() async {
    try {
      // 调用登出API
      await ApiClient.instance.auth.logout();
    } catch (e) {
      // 即使API调用失败也要清理本地状态
    }
    
    await _clearAuthData();
  }

  /// 刷新Token
  static Future<void> refreshToken() async {
    if (_token == null) return;
    
    try {
      final response = await ApiClient.instance.auth.refreshToken(_token!);
      await _saveAuthData(response);
    } catch (e) {
      // Token刷新失败，清理认证状态
      await _clearAuthData();
      rethrow;
    }
  }

  /// 修改密码
  static Future<void> changePassword(String oldPassword, String newPassword) async {
    final request = ChangePasswordRequest(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    await ApiClient.instance.auth.changePassword(request);
  }

  /// 忘记密码
  static Future<void> forgotPassword(String email) async {
    await ApiClient.instance.auth.forgotPassword(email);
  }

  /// 重置密码
  static Future<void> resetPassword(String token, String newPassword) async {
    final request = ResetPasswordRequest(
      token: token,
      newPassword: newPassword,
    );
    await ApiClient.instance.auth.resetPassword(request);
  }

  /// 保存认证数据
  static Future<void> _saveAuthData(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, response.token);
    await prefs.setInt(_userIdKey, response.id);
    await prefs.setString(_usernameKey, response.username);
    await prefs.setString(_emailKey, response.email);
    
    // 更新内存状态
    _token = response.token;
    _isLoggedIn = true;
    _currentUserId = response.id;
    _currentUsername = response.username;
    _currentEmail = response.email;
  }

  /// 清理认证数据
  static Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
    
    // 清理内存状态
    _token = null;
    _isLoggedIn = false;
    _currentUserId = null;
    _currentUsername = null;
    _currentEmail = null;
  }

  // Getters
  static bool get isLoggedIn => _isLoggedIn;
  static int? get currentUserId => _currentUserId;
  static String? get currentUsername => _currentUsername;
  static String? get currentEmail => _currentEmail;
  static String? get token => _token;
  
  /// 获取Token（兼容旧版API）
  static String? getToken() => _token;

  /// 检查是否需要登录
  static bool requiresAuth() => !_isLoggedIn;

  /// 检查Token是否即将过期
  static bool isTokenExpiringSoon() {
    // 这里可以解析JWT Token检查过期时间
    // 简化实现，返回false
    return false;
  }

  /// 自动刷新Token（如果需要）
  static Future<void> autoRefreshTokenIfNeeded() async {
    if (isTokenExpiringSoon()) {
      await refreshToken();
    }
  }
}