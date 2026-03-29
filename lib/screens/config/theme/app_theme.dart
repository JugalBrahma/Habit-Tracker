import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/config/colors/app_colors.dart';

class AppTheme {
  // Indigo color scheme
  //theme.colorScheme.onSurface
  static const Color primarySeed = AppColors.primarySeed; // Indigo for light theme
  static const Color primarySeedDark = AppColors.primarySeedDark; // Softer indigo for dark theme

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeed,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground, // Light grey background
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primarySeed,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeedDark,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.darkCard,
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primarySeedDark,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // Custom Gradients for "Premium" cards
  static LinearGradient get premiumGradient => LinearGradient(
    colors: [primarySeed, primarySeed.withOpacity(0.7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
