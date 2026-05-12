import 'package:flutter/material.dart';

class AppTheme {
  // Green Nature Theme from Figma
  static const Color primaryGreen = Color(0xFF95d878);
  static const Color backgroundDark = Color(0xFF1e1e1e);
  static const Color borderGreen = Color(0xFF2a3326);
  static const Color textPrimary = Color(0xFFe5e2e1);
  static const Color textSecondary = Color(0xFFc1c9b8);
  static const Color progressBarBg = Color(0xFF1e331a);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryGreen,
      background: backgroundDark,
      surface: backgroundDark,
      onPrimary: Colors.white,
      onBackground: textPrimary,
      onSurface: textPrimary,
    ),
    scaffoldBackgroundColor: backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Manrope',
        letterSpacing: -0.24,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderGreen, width: 1),
      ),
      color: backgroundDark,
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryGreen,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontFamily: 'Manrope',
        letterSpacing: -0.24,
      ),
      headlineMedium: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Manrope',
      ),
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'Manrope',
      ),
      bodyMedium: TextStyle(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: 'Manrope',
      ),
      labelMedium: TextStyle(
        color: textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontFamily: 'Manrope',
        letterSpacing: 0.6,
      ),
    ),
  );

  static final ThemeData darkTheme = lightTheme; // Same theme for both light and dark

  // Custom Gradients for "Premium" cards
  static LinearGradient get premiumGradient => LinearGradient(
    colors: [primaryGreen, primaryGreen.withOpacity(0.7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
