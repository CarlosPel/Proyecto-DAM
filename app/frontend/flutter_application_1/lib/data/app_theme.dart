import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true, // Activamos Material 3
      scaffoldBackgroundColor: const Color(0xFFF7F5EF), // fondo tipo piedra
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo.shade700,
        primary: Colors.indigo.shade700,
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
          backgroundColor: Colors.indigo.shade700,
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
