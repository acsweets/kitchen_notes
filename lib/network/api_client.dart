import 'api/auth_api.dart';
import 'api/recipe_api.dart';
import 'api/user_api.dart';
import 'api/upload_api.dart';
import 'api/category_api.dart';

/// API客户端统一入口
class ApiClient {
  static ApiClient? _instance;
  
  ApiClient._();
  
  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  // 各模块API实例
  final AuthApi auth = AuthApi();
  final RecipeApi recipe = RecipeApi();
  final UserApi user = UserApi();
  final UploadApi upload = UploadApi();
  final CategoryApi category = CategoryApi();
}