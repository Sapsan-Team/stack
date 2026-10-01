import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/features/locale/presentation/providers/locale_provider.dart';
import 'package:todo/features/theme/presentation/providers/theme_provider.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:todo/core/router/router.dart';
import 'package:todo/core/theme/colors.dart';
import 'package:todo/core/theme/app_theme.dart';
import 'package:todo/l10n/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final colorIndex = ref.watch(colorIndexProvider);
    final seedColor = seedColors[colorIndex];
    ref.watch(authNotifierProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(seedColor: seedColor, brightness: Brightness.light),
      darkTheme: AppTheme.build(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      themeMode: themeMode,
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(localeProvider),
      title: 'XStack',
    );
  }
}
