import 'package:flutter/material.dart';

class AppColors {
  // 背景色
  static const Color background = Color(0xFFFFF5E1); // 柔和奶油白色
  static const Color backgroundSecondary = Color(0xFFF5F5DC); // 浅米色
  
  // 主要按钮和突出元素
  static const Color primary = Color(0xFFFF7F32); // 胡椒橙
  static const Color secondary = Color(0xFF6DBE45); // 草绿色
  
  // 次要按钮和链接
  static const Color accent = Color(0xFFFF4F5A); // 番茄红
  static const Color highlight = Color(0xFFFFCC00); // 金黄色
  
  // 文字颜色
  static const Color textPrimary = Color(0xFF333333); // 深灰色
  static const Color textSecondary = Color(0xFFA0A0A0); // 淡灰色
  
  // 图标和其他小元素
  static const Color iconPrimary = Color(0xFF8B4513); // 深棕色
  
  // 状态颜色
  static const Color success = secondary;
  static const Color warning = highlight;
  static const Color error = accent;
  
  // 卡片和表面颜色
  static const Color surface = Colors.white;
  static const Color surfaceVariant = backgroundSecondary;
}