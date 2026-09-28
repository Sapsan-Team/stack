import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/router/routes.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/widgets/locale_button.dart';
import 'package:todo/widgets/theme_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navProfile),
        actions: const [
          LocaleButton(),
          ThemeButton(),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    (user?.displayName?.isNotEmpty == true
                            ? user!.displayName![0]
                            : user?.username?.isNotEmpty == true
                                ? user!.username![0]
                                : 'U')
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.displayName ?? user?.username ?? 'Пользователь',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (user?.username != null)
                  Text(
                    '@${user!.username}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                const SizedBox(height: 4),
                Text(
                  user?.phoneNumber ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(authNotifierProvider.notifier).logout();
                    if (context.mounted) {
                      context.go(Routes.auth);
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: Text(l10n.logoutButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
