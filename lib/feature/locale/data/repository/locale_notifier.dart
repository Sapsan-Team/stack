import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/providers/shared_preferences_provider.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final locale = prefs.getString('app_language') == 'ru'
        ? const Locale('ru')
        : const Locale('en');
    return locale;
  }

  void switchLocale() {
    final prefs = ref.read(sharedPreferencesProvider);
    if (state.languageCode == 'ru') {
      state = const Locale('en');
      prefs.setString('app_language', 'en');
    } else {
      state = const Locale('ru');
      prefs.setString('app_language', 'ru');
    }
  }
}