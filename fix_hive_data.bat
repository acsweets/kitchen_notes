@echo off
echo 修复Hive数据类型问题...
echo.

echo 1. 停止应用并清理Hive数据...
rmdir /s /q "%USERPROFILE%\AppData\Roaming\kitchen_notes" 2>nul
rmdir /s /q "%LOCALAPPDATA%\kitchen_notes" 2>nul

echo.
echo 2. 清理Flutter缓存...
flutter clean

echo.
echo 3. 重新获取依赖...
flutter pub get

echo.
echo 4. 重新生成适配器...
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs

echo.
echo 5. 重新启动应用...
flutter run -d windows

pause