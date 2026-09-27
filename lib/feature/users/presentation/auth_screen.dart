import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo/feature/users/presentation/providers/auth/auth_notifier_provider.dart';
import 'package:todo/l10n/app_localizations.dart';

class AuthScreen extends HookConsumerWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withValues(alpha: 0.1),
            ),
            child: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.authScreenTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    label: Text(
                      l10n.authScreenPhoneLabel,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    label: Text(
                      l10n.authScreenPasswordLabel,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final phone = phoneController.text;
                        final password = passwordController.text;
                        try {
                          await ref
                              .read(authNotifierProvider.notifier)
                              .login(phone, password);

                          if (context.mounted) {
                            // context.go('/home');
                          }
                        } catch (error) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('$error')));
                          }
                        }
                      },
                      child: Text(l10n.loginButton),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle signup action
                      },
                      child: Text(l10n.signupButton),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
