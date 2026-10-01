import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/features/theme/presentation/providers/theme_provider.dart';
import 'package:todo/l10n/app_localizations.dart';

class ThemeButton extends ConsumerWidget {
  const ThemeButton({super.key, this.padding = 8});
  final double padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeNotifierProvider);
    final isDark = mode == ThemeMode.dark;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(right: padding),
      child: IconButton(
        tooltip: isDark ? l10n.switchToLightTheme : l10n.switchToDarkTheme,
        onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme(),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            key: ValueKey(isDark),
          ),
        ),
      ),
    );
  }
}
