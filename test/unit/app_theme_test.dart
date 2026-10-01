import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/core/theme/app_theme.dart';

void main() {
  test('scaffold background stays neutral regardless of selected accent', () {
    final blueTheme = AppTheme.build(
      seedColor: const Color(0xFF496A81),
      brightness: Brightness.light,
    );
    final pinkTheme = AppTheme.build(
      seedColor: const Color(0xFFC2185B),
      brightness: Brightness.light,
    );

    expect(blueTheme.scaffoldBackgroundColor, const Color(0xFFF6F7F9));
    expect(
      pinkTheme.scaffoldBackgroundColor,
      blueTheme.scaffoldBackgroundColor,
    );
  });

  test('dark theme uses a neutral dark scaffold background', () {
    final theme = AppTheme.build(
      seedColor: const Color(0xFF496A81),
      brightness: Brightness.dark,
    );

    expect(theme.scaffoldBackgroundColor, const Color(0xFF111318));
  });
}
