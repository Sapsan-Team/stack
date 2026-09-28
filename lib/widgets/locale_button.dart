import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/feature/locale/data/repository/locale_provider.dart';

class LocaleButton extends ConsumerWidget {
  const LocaleButton({super.key, this.padding = 8});
  final double padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isRu = locale.languageCode == 'ru';

    return Padding(
      padding: EdgeInsets.only(right: padding),
      child: IconButton(
        tooltip: isRu ? 'Сменить язык' : 'Change language',
        onPressed: () => ref.read(localeProvider.notifier).switchLocale(),
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 20),
            const SizedBox(width: 4),
            Text(
              locale.languageCode.toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
