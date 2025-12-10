import 'package:flutter/material.dart';

/// This file holds all the theme configuration for Mental Zen
/// We're going for a calming, zen-like vibe with purple and blue tones
/// Think meditation, tranquility, and mental wellness

class AppTheme {
  // Our brand colors - purple and blue create that peaceful mental wellness feel
  static const Color primaryPurple = Color(0xFF6B46C1); // Deep purple
  static const Color primaryBlue = Color(0xFF3B82F6); // Calming blue
  static const Color accentPink = Color(0xFFEC4899); // Soft pink accent
  static const Color darkBackground = Color(0xFF1E1B2E); // Dark background for that modern look
  static const Color cardBackground = Color(0xFF2D2A3E); // Slightly lighter for cards
  static const Color textPrimary = Color(0xFFFFFFFF); // White text
  static const Color textSecondary = Color(0xFFB8B5C7); // Muted text for secondary info

  /// Main theme data for the app
  /// This gets used throughout the entire app to maintain consistency
  static ThemeData get darkTheme {
    return ThemeData(
      // Use dark theme as our base since it fits the zen aesthetic
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Primary color scheme - purple is our main brand color
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: primaryBlue,
        tertiary: accentPink,
        surface: cardBackground,
        background: darkBackground,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),

      // App bar theme - clean and minimal
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),

      // Card theme - rounded corners for that modern feel
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Button themes - rounded buttons that feel friendly
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),

      // Text theme - readable and calming
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
      ),

      // Input decoration theme - for text fields and forms
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
      ),

      // Scaffold background - our dark theme base
      scaffoldBackgroundColor: darkBackground,
    );
  }
}

