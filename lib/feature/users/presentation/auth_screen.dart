import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo/feature/users/presentation/providers/auth/auth_notifier_provider.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/widgets/theme_button.dart';

class AuthScreen extends HookConsumerWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);
    final isLoading = useState(false);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(spacing: 8, children: [ThemeButton()]),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
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
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    label: Text(
                      l10n.authScreenPhoneLabel,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword.value,
                  decoration: InputDecoration(
                    label: Text(
                      l10n.authScreenPasswordLabel,
                      style: const TextStyle(fontSize: 12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () {
                        obscurePassword.value = !obscurePassword.value;
                      },
                    ),
                  ),
                ),
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: isLoading.value
                          ? null
                          : () async {
                              final phone = phoneController.text.trim();
                              final password = passwordController.text;

                              if (phone.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Заполните все поля'),
                                  ),
                                );
                                return;
                              }

                              isLoading.value = true;
                              try {
                                final result = await ref
                                    .read(authNotifierProvider.notifier)
                                    .login(phone, password);

                                if (context.mounted) {
                                  result.fold(
                                    (failure) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(failure.message),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                                    (user) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.authSuccessMessage,
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      // context.go('/home');
                                    },
                                  );
                                }
                              } finally {
                                isLoading.value = false;
                              }
                            },
                      child: isLoading.value
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.loginButton),
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
