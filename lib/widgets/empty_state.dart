import 'package:flutter/material.dart';
import 'package:todo/l10n/app_localizations.dart';

class EmptyState extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData icon;

  const EmptyState({
    super.key,
    this.title,
    this.subtitle,
    this.icon = Icons.pets_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    final displayTitle = title ?? l10n?.emptyStateTitle ?? 'Здесь пока ничего нет';
    final displaySubtitle = subtitle ?? l10n?.emptyStateSubtitle ?? 'Список задач и питомцев пуст';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56,
                color: colorScheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              displayTitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              ':3',
              style: TextStyle(
                fontSize: 28,
                color: colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              displaySubtitle,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
