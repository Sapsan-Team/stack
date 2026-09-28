import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/providers/shared_preferences_provider.dart';
import 'package:todo/feature/theme/repository/settings_repository.dart';
import 'package:todo/feature/theme/data/repository/settings_repository_impl.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepositoryImpl(prefs: prefs);
});

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final repo = ref.watch(settingsRepositoryProvider);
    return repo.themeMode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setThemeMode(mode);
    state = mode;
  }

  Future<void> toggleTheme() async {
    const modes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];
    final currentIndex = modes.indexOf(state);
    final nextIndex =
        (currentIndex == -1 ? 0 : currentIndex + 1) % modes.length;
    await setThemeMode(modes[nextIndex]);
  }
}

class ColorNotifier extends Notifier<int> {
  @override
  int build() {
    final repo = ref.watch(settingsRepositoryProvider);
    return repo.colorIndex;
  }

  Future<void> setColorIndex(int index) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setColorIndex(index);
    state = index;
  }
}
