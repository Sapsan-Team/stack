import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/providers/shared_preferences_provider.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final locale = prefs.getString('app_language') == 'ru'
        ? Locale('ru')
        : Locale('en');
    return locale;
  }

  void switchLocale() {
    final prefs = ref.read(sharedPreferencesProvider);
    if (state == Locale('ru')) {
      state = Locale('en');
      prefs.setString('app_language', 'en');
    } else {
      state = Locale('ru');
      prefs.setString('app_language', 'ru');
    }
  }
}