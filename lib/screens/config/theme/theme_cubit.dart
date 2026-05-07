import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeBox = 'themePreferences';
  static const String _themeKey = 'isDarkMode';
  static const String _backgroundKey = 'selected_background';
  static const String _useBackgroundKey = 'use_custom_background';

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

  void toggleBackgroundImage(bool useBackground) {
    _saveBackgroundSettings(useBackground, null);
  }

  void setBackgroundImage(String backgroundPath) {
    _saveBackgroundSettings(true, backgroundPath);
  }

  static Future<void> _saveBackgroundSettings(bool useBackground, String? backgroundPath) async {
    try {
      final box = Hive.box(_themeBox);
      await box.put(_useBackgroundKey, useBackground);
      if (backgroundPath != null) {
        await box.put(_backgroundKey, backgroundPath);
      }
    } catch (e) {
      print('Error saving background settings: $e');
    }
  }

  static bool getUseCustomBackground() {
    try {
      final box = Hive.box(_themeBox);
      return box.get(_useBackgroundKey, defaultValue: false);
    } catch (e) {
      return false;
    }
  }

  static String? getSelectedBackground() {
    try {
      final box = Hive.box(_themeBox);
      return box.get(_backgroundKey);
    } catch (e) {
      return null;
    }
  }
}
