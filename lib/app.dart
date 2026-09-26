import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/feature/locale/data/repository/locale_provider.dart';
import 'package:todo/feature/theme/theme_provider.dart';
import 'package:todo/core/router/router.dart';
import 'package:todo/core/theme/colors.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final colorIndex = ref.watch(colorIndexProvider);
    final seedColor = seedColors[colorIndex];

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: seedColor,
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: 'Unbounded',
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: seedColor,
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Unbounded',
      ),
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      locale: ref.watch(localeProvider),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
      ],
      title: 'TODO',
    );
  }
}
