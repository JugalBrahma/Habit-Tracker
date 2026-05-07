import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundService extends ValueNotifier<String> {
  static const String _key = 'selected_background';

  BackgroundService() : super('assets/backgrounds/bg1.png') {
    _loadBackground();
  }

  Future<void> _loadBackground() async {
    final prefs = await SharedPreferences.getInstance();
    value = prefs.getString(_key) ?? 'assets/backgrounds/bg1.png';
  }

  Future<void> setBackground(String path) async {
    value = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, path);
  }
}
