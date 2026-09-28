import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/core/router/routes.dart';
import 'package:todo/core/utils/auth_validators.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/widgets/locale_button.dart';
import 'package:todo/widgets/theme_button.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final phoneController = useTextEditingController();
    final usernameController = useTextEditingController();
    final displayNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);
    final isLoading = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.registerScreenTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: const [
          LocaleButton(),
          ThemeButton(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).cardColor.withValues(alpha: 0.15),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                ),
              ),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.registerScreenTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Phone Number
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: l10n.authScreenPhoneLabel,
                        hintText: '+77011234567',
                        prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => AuthValidators.validatePhone(v, l10n),
                    ),
                    const SizedBox(height: 16),

                    // Username
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: l10n.usernameLabel,
                        hintText: 'john_doe',
                        prefixIcon: const Icon(Icons.alternate_email, size: 20),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => AuthValidators.validateUsername(v, l10n),
                    ),
                    const SizedBox(height: 16),

                    // Display Name
                    TextFormField(
                      controller: displayNameController,
                      decoration: InputDecoration(
                        labelText: l10n.displayNameLabel,
                        hintText: 'John Doe',
                        prefixIcon: const Icon(Icons.person_outline, size: 20),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          AuthValidators.validateDisplayName(v, l10n),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword.value,
                      decoration: InputDecoration(
                        labelText: l10n.authScreenPasswordLabel,
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        border: const OutlineInputBorder(),
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
                      validator: (v) => AuthValidators.validatePassword(v, l10n),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword.value,
                      decoration: InputDecoration(
                        labelText: l10n.confirmPasswordLabel,
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 20,
                          ),
                          onPressed: () {
                            obscureConfirmPassword.value =
                                !obscureConfirmPassword.value;
                          },
                        ),
                      ),
                      validator: (v) => AuthValidators.validateConfirmPassword(
                        v,
                        passwordController.text,
                        l10n,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isLoading.value
                          ? null
                          : () async {
                              if (!(formKey.currentState?.validate() ?? false)) {
                                return;
                              }

                              isLoading.value = true;
                              try {
                                final result = await ref
                                    .read(authNotifierProvider.notifier)
                                    .register(
                                      phone: phoneController.text.trim(),
                                      username: usernameController.text.trim(),
                                      displayName:
                                          displayNameController.text.trim(),
                                      password: passwordController.text,
                                    );

                                if (context.mounted) {
                                  result.fold(
                                    (failure) {
                                      final errorMessage = switch (failure) {
                                        AuthFailure(:final message?)
                                            when message.isNotEmpty =>
                                          message,
                                        AuthFailure() =>
                                          l10n.authInvalidCredentialsError,
                                        NetworkFailure(:final message?)
                                            when message.isNotEmpty =>
                                          message,
                                        NetworkFailure() =>
                                          l10n.networkErrorMessage,
                                        ServerFailure(:final message?)
                                            when message.isNotEmpty =>
                                          message,
                                        _ => l10n.serverErrorMessage,
                                      };

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(errorMessage),
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
                                            l10n.registerSuccessMessage,
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                  );
                                }
                              } finally {
                                isLoading.value = false;
                              }
                            },
                      child: isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              l10n.signupButton,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),

                    // Back to login button
                    TextButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(Routes.auth);
                        }
                      },
                      child: Text(l10n.alreadyHaveAccount),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
