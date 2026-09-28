import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/router/routes.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/widgets/empty_state.dart';
import 'package:todo/widgets/locale_button.dart';
import 'package:todo/widgets/theme_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeScreenTitle),
        actions: [
          const LocaleButton(),
          const ThemeButton(),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logoutButton,
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go(Routes.auth);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (user != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Theme.of(context)
                          .dividerColor
                          .withValues(alpha: 0.15),
                    ),
                  ),
                  color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Text(
                            (user.displayName?.isNotEmpty == true
                                    ? user.displayName![0]
                                    : user.username?.isNotEmpty == true
                                        ? user.username![0]
                                        : 'U')
                                .toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName?.isNotEmpty == true
                                    ? user.displayName!
                                    : (user.username ?? user.phoneNumber),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (user.username != null &&
                                  user.displayName != null)
                                Text(
                                  '@${user.username}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              Text(
                                user.phoneNumber,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const Expanded(
              child: EmptyState(),
            ),
          ],
        ),
      ),
    );
  }
}
