@echo off
chcp 65001 >nul
echo 🍳 灶边记 Flutter 项目启动脚本
echo ================================

:menu
echo.
echo 请选择运行平台:
echo 1. Windows 桌面应用
echo 2. Android 应用  
echo 3. Web 应用
echo 4. 查看可用设备
echo 5. 清理项目
echo 6. 退出
echo.

set /p choice=请输入选项 (1-6): 

if "%choice%"=="1" goto windows
if "%choice%"=="2" goto android  
if "%choice%"=="3" goto web
if "%choice%"=="4" goto devices
if "%choice%"=="5" goto clean
if "%choice%"=="6" goto exit

echo 无效选项，请重新选择
goto menu

:windows
echo 🖥️ 启动 Windows 桌面应用...
flutter run -d windows
goto menu

:android
echo 📱 启动 Android 应用...
flutter run -d android
goto menu

:web
echo 🌐 启动 Web 应用...
flutter run -d chrome
goto menu

:devices
echo 📋 查看可用设备...
flutter devices
pause
goto menu

:clean
echo 🧹 清理项目...
flutter clean
flutter pub get
echo ✅ 清理完成
pause
goto menu

:exit
echo 👋 再见！
exit