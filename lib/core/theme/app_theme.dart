import 'package:flutter/material.dart';

class AppTheme {
  // 主色调 - 明亮活泼的儿童配色
  static const Color primaryBlue = Color(0xFF4A90D9);      // 主蓝色
  static const Color primaryOrange = Color(0xFFFF8C42);  // 活力橙
  static const Color primaryGreen = Color(0xFF4CD964);    // 清新绿
  static const Color primaryPink = Color(0xFFFF6B9D);     // 樱花粉

  // 各年龄段主题色
  static const Color smallClassColor = Color(0xFF4A90D9);  // 小班 - 蓝色
  static const Color mediumClassColor = Color(0xFFFF8C42); // 中班 - 橙色
  static const Color largeClassColor = Color(0xFF4CD964);   // 大班 - 绿色

  // 背景渐变色
  static const Color backgroundPink = Color(0xFFFFF5F5);
  static const Color backgroundBlue = Color(0xFFF0F7FF);

  // 文本色
  static const Color textColor = Color(0xFF2D3436);
  static const Color textLight = Color(0xFF636E72);

  // 成功/错误色
  static const Color success = Color(0xFF4CD964);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFD93D);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundPink,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryOrange,
        tertiary: primaryGreen,
        surface: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(60, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(fontSize: 18, fontFamily: 'SimSun'),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        bodyLarge: TextStyle(fontSize: 18, color: textColor, fontFamily: 'SimSun'),
        bodyMedium: TextStyle(fontSize: 16, color: textColor, fontFamily: 'SimSun'),
      ),
    );
  }
}
