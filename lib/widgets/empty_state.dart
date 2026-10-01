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
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    final displayTitle =
        title ?? l10n?.emptyStateTitle ?? 'Здесь пока ничего нет';
    final displaySubtitle = subtitle ?? l10n?.emptyStateSubtitle ?? '';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              displayTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (displaySubtitle.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                displaySubtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
