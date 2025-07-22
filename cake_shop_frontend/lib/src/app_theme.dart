import 'package:flutter/material.dart';

/// Returns the application's dark theme with custom branding.
ThemeData buildDarkTheme() {
  // Branding colors
  const primary = Color(0xfff7b5d8);
  const secondary = Color(0xffFFF8DC);
  const accent = Color(0xff6A1B9A);

  // Dark background, bold accent
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accent,
      primary: primary,
      secondary: secondary,
      brightness: Brightness.dark,
      surface: Colors.grey[900]!,
    ),
    scaffoldBackgroundColor: Colors.black,
    dialogTheme: DialogTheme(
      backgroundColor: Colors.grey[900],
    ),
    primaryColor: primary,
    indicatorColor: accent,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff1a1a1a),
      titleTextStyle: TextStyle(
        color: primary,
        fontWeight: FontWeight.bold,
        fontSize: 21,
      ),
      iconTheme: IconThemeData(color: accent),
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff161519),
      selectedItemColor: accent,
      unselectedItemColor: secondary,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: secondary),
      headlineMedium: TextStyle(color: accent, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: primary, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(color: accent),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[850],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: accent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: secondary,
      selectedColor: accent,
      labelStyle: const TextStyle(color: Colors.black),
      secondaryLabelStyle: const TextStyle(color: accent),
      brightness: Brightness.dark,
    ),
    cardColor: Colors.grey[900],
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
