import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/feature/theme/repository/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.prefs});
  final SharedPreferences prefs;

  static const _modeKey = 'theme_mode';
  static const _colorKey = 'color_index';

  @override
  ThemeMode get themeMode =>
      ThemeMode.values[prefs.getInt(_modeKey) ?? ThemeMode.system.index];

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await prefs.setInt(_modeKey, mode.index);
  }

  @override
  int get colorIndex => prefs.getInt(_colorKey) ?? 0;

  @override
  Future<void> setColorIndex(int index) async {
    await prefs.setInt(_colorKey, index);
  }
}
