class NetworkConfig {
  static const String baseUrl = 'http://localhost:8080/api';
  
  // 超时配置
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // 默认请求头
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // API版本
  static const String apiVersion = 'v1';
  
  // 分页默认配置
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
}