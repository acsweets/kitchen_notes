@echo off
echo 启动灶边记Flutter应用...
echo.

echo 1. 清理项目缓存...
flutter clean

echo.
echo 2. 获取依赖包...
flutter pub get

echo.
echo 3. 生成Hive适配器...
flutter packages pub run build_runner build --delete-conflicting-outputs

echo.
echo 4. 启动应用...
flutter run -d windows

pause