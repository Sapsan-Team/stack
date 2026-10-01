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

    final isLoading = useState(false);
    final hasSubmitted = useState(false);

    return AppPageScaffold(
      title: l10n.registerScreenTitle,
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
                          title: l10n.registerScreenTitle,
                          subtitle: l10n.registerScreenSubtitle,
                    ),
                    const SizedBox(height: 24),

                    // Phone Number
                    AuthTextField(
                      controller: phoneController,
                      label: l10n.authScreenPhoneLabel,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: (v) => AuthValidators.validatePhone(v, l10n),
                    ),
                    const SizedBox(height: 16),

                    // Username
                    AuthTextField(
                      controller: usernameController,
                      label: l10n.usernameLabel,
                      icon: Icons.alternate_email,
                      textInputAction: TextInputAction.next,
                      hintText: 'john_doe',
                      validator: (v) => AuthValidators.validateUsername(v, l10n),
                    ),
                    const SizedBox(height: 16),

                    // Display Name
                    AuthTextField(
                      controller: displayNameController,
                      label: l10n.displayNameLabel,
                      icon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      hintText: 'John Doe',
                      validator: (v) =>
                          AuthValidators.validateDisplayName(v, l10n),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    AuthPasswordField(
                        controller: passwordController,
                        label: l10n.authScreenPasswordLabel,
                        textInputAction: TextInputAction.next,
                        validator: (v) => AuthValidators.validatePassword(v, l10n),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    AuthPasswordField(
                        controller: confirmPasswordController,
                        label: l10n.confirmPasswordLabel,
                        textInputAction: TextInputAction.done,
                      validator: (v) => AuthValidators.validateConfirmPassword(
                        v,
                        passwordController.text,
                        l10n,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    AuthSubmitButton(
                      label: l10n.signupButton,
                      isLoading: isLoading.value,
                      onPressed: isLoading.value ? null : () async {
                              hasSubmitted.value = true;
                              if (!(formKey.currentState?.validate() ?? false)) {
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
                                    .register(
                                      phone: phoneNumber,
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
      ),)
    );
  }
}
