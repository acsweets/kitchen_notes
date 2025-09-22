import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        background: AppColors.background,
        onBackground: AppColors.onBackground,
        error: AppColors.error,
        onError: AppColors.onError,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(0, 48),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return AppColors.buttonDisabled;
            if (states.contains(MaterialState.pressed)) return AppColors.buttonPressed;
            if (states.contains(MaterialState.hovered)) return AppColors.buttonHovered;
            return AppColors.primary;
          }),
          elevation: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return 0;
            if (states.contains(MaterialState.pressed)) return 1;
            if (states.contains(MaterialState.hovered)) return 4;
            return 2;
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          minimumSize: const Size(0, 48),
        ).copyWith(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return AppColors.buttonDisabled;
            if (states.contains(MaterialState.pressed)) return AppColors.onPrimary;
            return AppColors.primary;
          }),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) return AppColors.primary;
            return Colors.transparent;
          }),
          overlayColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) return AppColors.primaryContainer;
            if (states.contains(MaterialState.pressed)) return AppColors.primary;
            return null;
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(0, 36),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) return AppColors.primaryContainer;
            if (states.contains(MaterialState.pressed)) return AppColors.secondary;
            return null;
          }),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        highlightElevation: 8,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          highlightColor: AppColors.primaryContainer,
          iconSize: 24,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.all(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputFocused, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputError, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 16),
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        errorStyle: const TextStyle(color: AppColors.inputError, fontSize: 12),
        helperStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        headlineLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        headlineMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textTertiary),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textTertiary),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
      ),
    );
  }
}