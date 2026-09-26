import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/feature/theme/theme_provider.dart';

class ThemeButton extends ConsumerWidget {
  const ThemeButton({super.key, this.padding = 8});
  final double padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeNotifierProvider);
    return Padding(
      padding: EdgeInsets.only(right: padding),
      child: IconButton(
        onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme(),
        icon: Icon(_iconForMode(mode)),
      ),
    );
  }

  IconData _iconForMode(ThemeMode mode) => switch (mode) {
    ThemeMode.light => Icons.dark_mode,
    ThemeMode.dark => Icons.brightness_auto,
    ThemeMode.system => Icons.light_mode,
  };
}
