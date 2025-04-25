import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Основные цвета приложения
  // static const Color primaryColor = Color(0xFF8F93DC); // Фиолетовый цвет
  static const Color accentColor = Colors.white70; // Светлый фиолетовый
  // static const Color textColor = Colors.black;
  // static const Color mainBackColor = Color(0xFFECEDFD);
  // static const Color widgetColor = Color(0xFFDBE0F5);
  // static const Color iconsSecond = Color(0xFF95AE4E);

  static const Color darkBack = Color(0xFF4B5267);
  static const Color widgetColorBlack  = Color(0xFFF5F5F5);

  // static const Color primaryColor = Color(0xFF54577C);
  static const Color primaryColor = Colors.black;
  static const Color mainBackColor = Colors.white;
  static const Color textColor = Colors.black;
  static const Color widgetColor = Color(0xFFF1F1F1);
  static const Color cardGreen = Color(0xFF008D00);
  static const Color greenlight = Color(0xFF1DB73F);
  static const Color iconsSecond = Color(0xFFF4AF1B);
  static const Color progressMain = Color(0xFFEBB644);
  static const Color progressBack = Color(0xFFF2E4CC);


  // Основная тема приложения
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme:  AppBarTheme(
        backgroundColor: primaryColor,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),

      textTheme: TextTheme(
        bodyLarge: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 22,
            fontWeight: FontWeight.w700
        ),
        titleLarge: GoogleFonts.poppins(
          color: textColor,
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: textColor
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w600
        ),
        bodyMedium: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        bodySmall: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ) ,
        headlineLarge: GoogleFonts.poppins(
          color: textColor,
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),

      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: accentColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.poppins(
          color: Colors.black54
        ),
      ),
    );
  }

}
