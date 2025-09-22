# 灶边记 - 多平台运行配置指南

## 🚀 快速启动

### Windows
```bash
# 双击运行或在命令行执行
run.bat
```

### macOS/Linux
```bash
# 给脚本执行权限
chmod +x run.sh
# 运行脚本
./run.sh
```

## 📱 平台支持

| 平台 | 状态 | 要求 | 命令 |
|------|------|------|------|
| 🖥️ Windows | ✅ 支持 | Windows 10+ | `flutter run -d windows` |
| 🤖 Android | ✅ 支持 | Android SDK | `flutter run -d android` |
| 📱 iOS | ✅ 支持 | macOS + Xcode | `flutter run -d ios` |
| 💻 macOS | ✅ 支持 | macOS 10.14+ | `flutter run -d macos` |
| 🐧 Linux | ✅ 支持 | Linux + GTK | `flutter run -d linux` |
| 🌐 Web | ✅ 支持 | Chrome | `flutter run -d chrome` |

## 🛠️ 环境配置

### 1. Flutter SDK
```bash
# 检查 Flutter 环境
flutter doctor

# 安装依赖
flutter pub get

# 生成代码
flutter packages pub run build_runner build
```

### 2. 平台特定配置

#### Windows 桌面
- 需要 Visual Studio 2022 或 Visual Studio Build Tools
- 启用 "Desktop development with C++" 工作负载

#### Android
- 安装 Android Studio
- 配置 Android SDK
- 创建 Android 虚拟设备 (AVD)

#### iOS (仅 macOS)
- 安装 Xcode 14+
- 配置 iOS 模拟器
- 苹果开发者账号 (真机调试)

#### macOS 桌面
- macOS 10.14 Mojave 或更高版本
- Xcode 命令行工具

#### Linux 桌面
```bash
# Ubuntu/Debian
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev

# Fedora
sudo dnf install clang cmake ninja-build pkg-config gtk3-devel
```

#### Web
- Chrome 浏览器
- 启用 Flutter Web 支持: `flutter config --enable-web`

## 🔧 开发工具

### VS Code 扩展
- Flutter
- Dart
- Flutter Widget Snippets

### Android Studio 插件
- Flutter
- Dart

## 📦 项目结构

```
kitchen_notes/
├── lib/                    # 主要代码
│   ├── main.dart          # 应用入口
│   ├── theme/             # 主题配置
│   ├── models/            # 数据模型
│   ├── providers/         # 状态管理
│   ├── screens/           # 页面
│   └── widgets/           # 组件
├── assets/                # 资源文件
├── android/               # Android 配置
├── ios/                   # iOS 配置
├── web/                   # Web 配置
├── windows/               # Windows 配置
├── macos/                 # macOS 配置
├── linux/                 # Linux 配置
├── run.bat               # Windows 启动脚本
├── run.sh                # Unix 启动脚本
└── pubspec.yaml          # 项目配置
```

## 🎨 设计系统

### 配色方案
- **主色调**: `#4CAF50` (现代绿色)
- **辅助色**: `#A5D6A7` (柔和绿色)  
- **背景色**: `#FAFAFA` (浅灰白)
- **错误色**: `#E53935` (现代红色)
- **警告色**: `#FF9800` (橙色)

### 组件库
- `CustomTextField` - 统一输入框
- `SearchTextField` - 搜索框
- `NumberInputField` - 数字输入框
- `PrimaryButton` - 主要按钮
- `SecondaryButton` - 次要按钮
- `CustomFloatingActionButton` - 浮动按钮

## 🐛 常见问题

### 1. 构建失败
```bash
# 清理项目
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 2. 设备未识别
```bash
# 查看可用设备
flutter devices

# 重启 ADB (Android)
adb kill-server
adb start-server
```

### 3. 热重载不工作
- 检查文件保存
- 重启调试会话
- 使用 `r` 热重载，`R` 热重启

### 4. 依赖冲突
```bash
# 更新依赖
flutter pub upgrade

# 解决冲突
flutter pub deps
```

## 📝 开发注意事项

1. **状态管理**: 使用 Provider 模式
2. **本地存储**: 使用 Hive 数据库
3. **图片处理**: 支持本地图片选择
4. **搜索功能**: 支持拼音搜索
5. **响应式设计**: 适配不同屏幕尺寸

## 🚀 部署

### Android APK
```bash
flutter build apk --release
```

### iOS IPA
```bash
flutter build ios --release
```

### Windows 可执行文件
```bash
flutter build windows --release
```

### Web 部署
```bash
flutter build web --release
```

## 📞 技术支持

如遇到问题，请检查：
1. Flutter 版本兼容性
2. 平台特定配置
3. 依赖版本冲突
4. 设备连接状态