import 'package:flutter/material.dart';

class AppTheme {
  // Основные цвета приложения
  static const Color primaryColor = Color(0xFF8F93DC); // Фиолетовый цвет
  static const Color accentColor = Color(0xFFEEF2FF); // Светлый фиолетовый
  static const Color textColor = Colors.black;
  static const Color mainBackColor = Color(0xFFECEDFD);
  static const Color widgetColor = Color(0xFFDBE0F5);
  static const Color iconsSecond = Color(0xFF95AE4E);


  // Основная тема приложения
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textColor,
          fontSize: 14,
        ),
        headlineLarge: TextStyle(
          color: textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: accentColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(
          color: Colors.black54,
        ),
      ),
    );
  }
}
