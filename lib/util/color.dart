import 'package:flutter/material.dart';

const MaterialColor primaryColor = MaterialColor(
  0xFF1E88E5, // Primary blue color (mid-range blue)
  <int, Color>{
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(0xFF1E88E5),
    600: Color(0xFF1976D2),
    700: Color(0xFF1565C0),
    800: Color(0xFF0D47A1),
    900: Color(0xFF0B3D91),
  },
);

final ThemeData streamlyTheme = ThemeData(
  primarySwatch: primaryColor,
  primaryColor: Color(0xFF1E88E5), // Used as the primary color in the theme
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor.shade700,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor.shade600,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor.shade600, // Use foregroundColor for text
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor.shade600,
      foregroundColor: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.blue[50],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: primaryColor.shade200),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: primaryColor.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: primaryColor.shade400),
    ),
  ),
  textTheme: TextTheme(
    displayLarge:
        TextStyle(color: primaryColor.shade900, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: primaryColor.shade800),
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black54),
  ),
  iconTheme: IconThemeData(
    color: primaryColor.shade700,
  ),
);
