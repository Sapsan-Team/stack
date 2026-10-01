import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/core/router/routes.dart';
import 'package:todo/core/utils/auth_validators.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/widgets/app_page_scaffold.dart';
import 'package:todo/widgets/auth_form_components.dart';

class AuthScreen extends HookConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final hasSubmitted = useState(false);

    return AppPageScaffold(
      title: '',
      body: AuthFormCard(
        child: Form(
                key: formKey,
                autovalidateMode: hasSubmitted.value
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthFormHeader(
                          title: l10n.authScreenTitle,
                          subtitle: l10n.authScreenSubtitle,
                    ),
                    const SizedBox(height: 24),

                    // Phone field
                    AuthTextField(
                      controller: phoneController,
                      label: l10n.authScreenPhoneLabel,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          AuthValidators.validatePhone(value, l10n),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    AuthPasswordField(
                        controller: passwordController,
                        label: l10n.authScreenPasswordLabel,
                        textInputAction: TextInputAction.done,
                        validator: (v) =>
                            AuthValidators.validatePassword(v, l10n),
                    ),
                    const SizedBox(height: 24),

                    // Login button
                    AuthSubmitButton(
                      label: l10n.loginButton,
                      isLoading: isLoading.value,
                      onPressed: isLoading.value ? null : () async {
                              hasSubmitted.value = true;
                              if (!(formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              final phoneNumber =
                                  AuthValidators.normalizePhoneNumber(
                                    phoneController.text,
                                  );
                              if (phoneNumber == null) {
                                return;
                              }

                              isLoading.value = true;
                              try {
                                final result = await ref
                                    .read(authNotifierProvider.notifier)
                                    .login(phoneNumber, passwordController.text);

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
                                        ),
                                      );
                                      context.go(Routes.home);
                                    },
                                  );
                                }
                              } finally {
                                isLoading.value = false;
                              }
                            },
                    ),
                    const SizedBox(height: 12),

                    // Signup navigation button
                    OutlinedButton(
                      onPressed: () {
                        context.push(Routes.register);
                      },
                      child: Text(
                        l10n.dontHaveAccount,
                      ),
                    ),
          ],
        ),
      ),)
    );
  }
}
