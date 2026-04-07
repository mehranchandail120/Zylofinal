import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color lightBlue = Color(0xFFE0F2FE);
  static const Color darkBlue = Color(0xFF0284C7);
  static const Color black = Color(0xFF0C1A2E);
  static const Color background = Color(0xFFF0F2F5);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: darkBlue,
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: black),
        titleTextStyle: TextStyle(
          color: darkBlue,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectanglePathBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}