import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/features/theme/presentation/providers/theme_notifier.dart';

final themeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

final colorIndexProvider = NotifierProvider<ColorNotifier, int>(
  ColorNotifier.new,
);
