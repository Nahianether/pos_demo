import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF3498DB);
  static const Color lightSecondary = Color(0xFF27AE60);
  static const Color lightAccent = Color(0xFF9B59B6);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF2C3E50);
  static const Color lightTextSecondary = Color(0xFF7F8C8D);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightError = Color(0xFFE74C3C);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF3498DB);
  static const Color darkSecondary = Color(0xFF27AE60);
  static const Color darkAccent = Color(0xFF9B59B6);
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2C2C2C);
  static const Color darkSurfaceVariant = Color(0xFF3A3A3A);
  static const Color darkTextPrimary = Color(0xFFECF0F1);
  static const Color darkTextSecondary = Color(0xFFBDC3C7);
  static const Color darkBorder = Color(0xFF4A4A4A);
  static const Color darkError = Color(0xFFE74C3C);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: lightPrimary,
      secondary: lightSecondary,
      surface: lightSurface,
      error: lightError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: lightTextPrimary,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: lightBackground,
    cardColor: lightSurface,
    dividerColor: lightBorder,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: lightSurface,
      foregroundColor: lightTextPrimary,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightPrimary, width: 2),
      ),
    ),
    iconTheme: const IconThemeData(color: lightTextPrimary),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkSecondary,
      surface: darkSurface,
      error: darkError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: darkTextPrimary,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkSurface,
    dividerColor: darkBorder,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkTextPrimary,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkPrimary, width: 2),
      ),
    ),
    iconTheme: const IconThemeData(color: darkTextPrimary),
  );

  // Helper method to get text color based on theme
  static Color getTextColor(bool isDark) {
    return isDark ? darkTextPrimary : lightTextPrimary;
  }

  static Color getSecondaryTextColor(bool isDark) {
    return isDark ? darkTextSecondary : lightTextSecondary;
  }

  static Color getSurfaceColor(bool isDark) {
    return isDark ? darkSurface : lightSurface;
  }

  static Color getBackgroundColor(bool isDark) {
    return isDark ? darkBackground : lightBackground;
  }

  static Color getBorderColor(bool isDark) {
    return isDark ? darkBorder : lightBorder;
  }

  static Color getSurfaceVariantColor(bool isDark) {
    return isDark ? darkSurfaceVariant : const Color(0xFFF8F9FA);
  }
}
