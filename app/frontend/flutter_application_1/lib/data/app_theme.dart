import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color postBackgroundColor = Color.fromARGB(255, 255, 255, 255);
  static const Color articleBackgroundColor =
      Color(0xFFF5EAD6);
  static const Color darkBrown = Color(0xff6f5335);
  static const Color lightBrown = Color(0xFFE5D8C3);
  static const Color lightMarbel = Color(0xFFF5F5F5);
  static const Color softGray = Color(0xFFCCCCCC);
  static const Color accentGold = Color(0xFFCDA34F);
  static const Color lightBlack = Color.fromRGBO(81, 81, 81, 1);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBrown, // fondo tipo piedra
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: darkBrown,
        secondary: lightBrown,
        surface: lightMarbel,
      ),
      textTheme: GoogleFonts.ptSerifTextTheme().copyWith(
        bodyLarge: TextStyle(color: lightBlack, fontSize: 20),
        bodyMedium: TextStyle(color: lightBlack, fontSize: 17),
        titleLarge: TextStyle(
          color: lightBlack,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        titleMedium: TextStyle(
          color: lightBlack,
          fontSize: 20,
        ),
        headlineLarge: TextStyle(
          color: darkBrown,
          fontWeight: FontWeight.bold,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightMarbel,
        foregroundColor: lightBlack,
        elevation: 4,
        titleTextStyle: GoogleFonts.ptSerif(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: lightBlack,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightMarbel,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: Colors.black26,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        prefixIconColor: lightBlack,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: softGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentGold),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: darkBrown,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            iconColor: Colors.white,
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(darkBrown),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
        textStyle: TextStyle(fontStyle: FontStyle.italic),
      )),
    );
  }
}
