import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/theme_preference.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _boxName = 'theme_preferences';
  static const String _key = 'current_theme';

  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final box = await Hive.openBox<ThemePreference>(_boxName);
      final themePreference = box.get(_key);

      if (themePreference != null) {
        state = _convertToThemeMode(themePreference.themeMode);
      }
    } catch (e) {
      // If there's an error, default to light theme
      state = ThemeMode.light;
    }
  }

  Future<void> setTheme(AppThemeMode themeMode) async {
    try {
      final box = await Hive.openBox<ThemePreference>(_boxName);
      final preference = ThemePreference(
        themeMode: themeMode,
        lastUpdated: DateTime.now(),
      );

      await box.put(_key, preference);
      state = _convertToThemeMode(themeMode);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
    await setTheme(newMode);
  }

  ThemeMode _convertToThemeMode(AppThemeMode appThemeMode) {
    switch (appThemeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  AppThemeMode get currentAppThemeMode {
    switch (state) {
      case ThemeMode.light:
        return AppThemeMode.light;
      case ThemeMode.dark:
        return AppThemeMode.dark;
      case ThemeMode.system:
        return AppThemeMode.system;
    }
  }

  bool get isDarkMode {
    return state == ThemeMode.dark;
  }
}

// Provider for theme
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// Provider to check if dark mode is active
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == ThemeMode.dark;
});
