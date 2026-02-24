import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeBox = 'themePreferences';
  static const String _themeKey = 'isDarkMode';

  ThemeCubit() : super(_loadTheme());

  static ThemeMode _loadTheme() {
    try {
      final box = Hive.box(_themeBox);
      final isDarkMode = box.get(_themeKey, defaultValue: false);
      return isDarkMode ? ThemeMode.dark : ThemeMode.light;
    } catch (e) {
      return ThemeMode.light;
    }
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(newMode);
    emit(newMode);
  }

  static Future<void> _saveTheme(ThemeMode mode) async {
    try {
      final box = Hive.box(_themeBox);
      await box.put(_themeKey, mode == ThemeMode.dark);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }
}
