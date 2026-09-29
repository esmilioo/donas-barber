import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'SF Pro Display',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentRose,
        surface: AppColors.surface,
        onPrimary: AppColors.onAccent,
        onSurface: AppColors.textPrimary,
      ),
      useMaterial3: true,
      dividerColor: AppColors.border,
    );
  }
}