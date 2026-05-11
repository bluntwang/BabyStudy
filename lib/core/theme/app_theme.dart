import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF5B9BD5);
  static const Color secondaryColor = Color(0xFFFF9F43);
  static const Color accentColor = Color(0xFF2ECC71);
  static const Color backgroundColor = Color(0xFFFFF5F5);
  static const Color textColor = Color(0xFF333333);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
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
