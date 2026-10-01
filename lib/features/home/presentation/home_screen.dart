import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/router/routes.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/widgets/empty_state.dart';
import 'package:todo/widgets/app_page_scaffold.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return AppPageScaffold(
      title: l10n.homeScreenTitle,
      actions: [
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
      body: const SafeArea(child: EmptyState()),
    );
  }
}
