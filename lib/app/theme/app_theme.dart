import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // --- Colors ---
  static const Color primaryColor = Colors.black;
  static const Color accentColor = Colors.white;
  static const Color backgroundColor = Colors.white;
  static const Color cardColor = Color(0xFFF5F5F5); // A very light grey
  static const Color textColor = Colors.black;
  static const Color subtleTextColor = Colors.grey;
  static const Color borderColor = Color(0xFFE0E0E0); // Light grey for borders

  /// --- THEME --- 
  static ThemeData get monochromeTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: primaryColor, // For FAB, etc.
        surface: backgroundColor,
        background: backgroundColor,
        error: Colors.black, // Errors will also be monochrome
        onPrimary: accentColor,
        onSecondary: accentColor,
        onSurface: textColor,
        onBackground: textColor,
        onError: accentColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme.copyWith(
          displayLarge: const TextStyle(color: textColor, fontWeight: FontWeight.bold),
          displayMedium: const TextStyle(color: textColor, fontWeight: FontWeight.bold),
          displaySmall: const TextStyle(color: textColor, fontWeight: FontWeight.bold),
          headlineMedium: const TextStyle(color: textColor, fontWeight: FontWeight.bold),
          headlineSmall: const TextStyle(color: textColor, fontWeight: FontWeight.bold),
          titleLarge: const TextStyle(color: textColor, fontWeight: FontWeight.bold),
          bodyLarge: const TextStyle(color: textColor),
          bodyMedium: const TextStyle(color: subtleTextColor),
          labelLarge: const TextStyle(color: accentColor, fontWeight: FontWeight.bold), // For buttons
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.black, // Use black background for cards
        elevation: 4, // Add a subtle shadow
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: Colors.white, // Use white text inside cards
        iconColor: Colors.white, // Use white icons inside cards
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: accentColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
        ),
        labelStyle: const TextStyle(color: subtleTextColor),
        floatingLabelStyle: const TextStyle(color: primaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: accentColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(accentColor),
        side: const BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: subtleTextColor,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
      ),
    );
  }
}
