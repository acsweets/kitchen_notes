#!/bin/bash

echo "🍳 灶边记 Flutter 项目启动脚本"
echo "================================"

show_menu() {
    echo ""
    echo "请选择运行平台:"
    echo "1. macOS 桌面应用"
    echo "2. iOS 应用"
    echo "3. Android 应用"
    echo "4. Linux 桌面应用"
    echo "5. Web 应用"
    echo "6. 查看可用设备"
    echo "7. 清理项目"
    echo "8. 退出"
    echo ""
}

while true; do
    show_menu
    read -p "请输入选项 (1-8): " choice
    
    case $choice in
        1)
            echo "🖥️ 启动 macOS 桌面应用..."
            flutter run -d macos
            ;;
        2)
            echo "📱 启动 iOS 应用..."
            flutter run -d ios
            ;;
        3)
            echo "🤖 启动 Android 应用..."
            flutter run -d android
            ;;
        4)
            echo "🐧 启动 Linux 桌面应用..."
            flutter run -d linux
            ;;
        5)
            echo "🌐 启动 Web 应用..."
            flutter run -d chrome
            ;;
        6)
            echo "📋 查看可用设备..."
            flutter devices
            read -p "按回车键继续..."
            ;;
        7)
            echo "🧹 清理项目..."
            flutter clean
            flutter pub get
            echo "✅ 清理完成"
            read -p "按回车键继续..."
            ;;
        8)
            echo "👋 再见！"
            exit 0
            ;;
        *)
            echo "❌ 无效选项，请重新选择"
            ;;
    esac
done