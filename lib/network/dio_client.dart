import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../services/auth_service.dart';
import 'network_config.dart';

class DioClient {
  static DioClient? _instance;
  late Dio _dio;

  DioClient._() {
    _dio = Dio();
    _setupInterceptors();
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    // 基础配置
    _dio.options = BaseOptions(
      baseUrl: NetworkConfig.baseUrl,
      connectTimeout: NetworkConfig.connectTimeout,
      receiveTimeout: NetworkConfig.receiveTimeout,
      sendTimeout: NetworkConfig.sendTimeout,
      headers: NetworkConfig.defaultHeaders,
    );

    // 认证拦截器
    _dio.interceptors.add(AuthInterceptor());

    // 日志拦截器
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));

    // 错误处理拦截器
    _dio.interceptors.add(ErrorInterceptor());
  }
}

/// 认证拦截器
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 添加认证头
    if (AuthService.isLoggedIn) {
      final token = AuthService.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    
    // 添加请求ID用于日志追踪
    options.headers['X-Request-ID'] = DateTime.now().millisecondsSinceEpoch.toString();
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 可以在这里处理通用响应逻辑
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 处理401未授权错误
    if (err.response?.statusCode == 401) {
      AuthService.logout();
    }
    
    super.onError(err, handler);
  }
}

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final networkError = _handleError(err);
    
    // 创建自定义错误
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: networkError,
      message: networkError.message,
    );
    
    super.onError(customError, handler);
  }

  NetworkError _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkError(
          code: 'CONNECTION_TIMEOUT',
          message: '连接超时，请检查网络连接',
          type: NetworkErrorType.timeout,
        );
      
      case DioExceptionType.sendTimeout:
        return NetworkError(
          code: 'SEND_TIMEOUT',
          message: '请求发送超时',
          type: NetworkErrorType.timeout,
        );
      
      case DioExceptionType.receiveTimeout:
        return NetworkError(
          code: 'RECEIVE_TIMEOUT',
          message: '响应接收超时',
          type: NetworkErrorType.timeout,
        );
      
      case DioExceptionType.badResponse:
        return _handleHttpError(error.response!);
      
      case DioExceptionType.cancel:
        return NetworkError(
          code: 'REQUEST_CANCELLED',
          message: '请求已取消',
          type: NetworkErrorType.cancel,
        );
      
      case DioExceptionType.unknown:
        return NetworkError(
          code: 'NETWORK_ERROR',
          message: '网络连接失败，请检查网络设置',
          type: NetworkErrorType.network,
        );
      
      default:
        return NetworkError(
          code: 'UNKNOWN_ERROR',
          message: '未知错误',
          type: NetworkErrorType.unknown,
        );
    }
  }

  NetworkError _handleHttpError(Response response) {
    final statusCode = response.statusCode ?? 0;
    
    switch (statusCode) {
      case 400:
        return NetworkError(
          code: 'BAD_REQUEST',
          message: '请求参数错误',
          type: NetworkErrorType.client,
          statusCode: statusCode,
          data: response.data,
        );
      
      case 401:
        return NetworkError(
          code: 'UNAUTHORIZED',
          message: '未授权，请重新登录',
          type: NetworkErrorType.auth,
          statusCode: statusCode,
        );
      
      case 403:
        return NetworkError(
          code: 'FORBIDDEN',
          message: '权限不足',
          type: NetworkErrorType.auth,
          statusCode: statusCode,
        );
      
      case 404:
        return NetworkError(
          code: 'NOT_FOUND',
          message: '请求的资源不存在',
          type: NetworkErrorType.client,
          statusCode: statusCode,
        );
      
      case 422:
        return NetworkError(
          code: 'VALIDATION_ERROR',
          message: '数据验证失败',
          type: NetworkErrorType.client,
          statusCode: statusCode,
          data: response.data,
        );
      
      case 500:
        return NetworkError(
          code: 'SERVER_ERROR',
          message: '服务器内部错误',
          type: NetworkErrorType.server,
          statusCode: statusCode,
        );
      
      case 502:
        return NetworkError(
          code: 'BAD_GATEWAY',
          message: '网关错误',
          type: NetworkErrorType.server,
          statusCode: statusCode,
        );
      
      case 503:
        return NetworkError(
          code: 'SERVICE_UNAVAILABLE',
          message: '服务暂时不可用',
          type: NetworkErrorType.server,
          statusCode: statusCode,
        );
      
      default:
        return NetworkError(
          code: 'HTTP_ERROR',
          message: 'HTTP错误: $statusCode',
          type: statusCode >= 500 ? NetworkErrorType.server : NetworkErrorType.client,
          statusCode: statusCode,
        );
    }
  }
}

/// 网络错误类型
enum NetworkErrorType {
  network,
  timeout,
  server,
  client,
  auth,
  cancel,
  unknown,
}

/// 网络错误模型
class NetworkError {
  final String code;
  final String message;
  final NetworkErrorType type;
  final int? statusCode;
  final dynamic data;

  NetworkError({
    required this.code,
    required this.message,
    required this.type,
    this.statusCode,
    this.data,
  });

  @override
  String toString() {
    return 'NetworkError(code: $code, message: $message, type: $type, statusCode: $statusCode)';
  }
}