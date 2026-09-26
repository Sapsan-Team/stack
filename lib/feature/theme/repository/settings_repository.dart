import 'package:flutter/material.dart';

abstract class SettingsRepository {
  ThemeMode get themeMode;
  Future<void> setThemeMode(ThemeMode mode);
  int get colorIndex;
  Future<void> setColorIndex(int index);
}
