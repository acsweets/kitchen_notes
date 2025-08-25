# 灶边记 Flutter 应用启动指南

## 🚀 快速启动

### Windows 用户
双击运行 `start.bat` 文件

### Linux/Mac 用户
```bash
chmod +x start.sh
./start.sh
```

## 📋 手动启动步骤

### 1. 环境检查
确保已安装：
- Flutter SDK (3.6.2+)
- Dart SDK
- Android Studio 或 VS Code
- Windows 开发环境（Windows 用户）

### 2. 依赖安装
```bash
flutter pub get
```

### 3. 代码生成
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 4. 运行应用
```bash
# Windows
flutter run -d windows

# Android 模拟器
flutter run -d android

# iOS 模拟器 (Mac only)
flutter run -d ios

# Chrome 浏览器
flutter run -d chrome
```

## 🔧 常见问题解决

### 问题1: 构建失败
```bash
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 问题2: 依赖冲突
```bash
flutter pub deps
flutter pub upgrade
```

### 问题3: Hive适配器错误
```bash
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📱 支持的平台

- ✅ Windows (推荐)
- ✅ Android
- ✅ Web (Chrome)
- ✅ iOS (Mac only)

## 🌐 后端服务

确保后端服务运行在 `http://localhost:8080`

如需修改后端地址，请编辑：
`lib/services/api_service.dart` 中的 `baseUrl` 变量

## 📝 功能特性

- 📖 本地菜谱管理
- 🥘 食材库存管理  
- 🤖 智能推荐系统
- 👥 社区菜谱分享
- 🔐 用户认证系统
- 📊 制作记录统计

## 🆘 获取帮助

如遇到问题，请检查：
1. Flutter 版本是否正确
2. 依赖包是否完整安装
3. 代码生成是否成功
4. 后端服务是否正常运行