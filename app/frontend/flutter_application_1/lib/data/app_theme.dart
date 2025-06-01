import 'package:flutter/material.dart';

class AppTheme {
  static Color newsPaperBackgroundColor = Color.fromARGB(130, 230, 219, 116);
  static Color postBackgroundColor = Color.fromARGB(255, 255, 255, 255);
  static Color articleBackgroundColor = Color.fromARGB(130, 230, 219, 116);
  static Color primary =  const Color(0xff6f5335);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true, // Activamos Material 3
      scaffoldBackgroundColor: const Color(0xffd1d1c6), // fondo tipo piedra
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo.shade700,
        primary: primary,
        secondary: Colors.indigo.shade200,
        surface: const Color(0xFFF7F5EF),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          iconColor: Colors.white,
        ),
      ),
    );
  }
}
