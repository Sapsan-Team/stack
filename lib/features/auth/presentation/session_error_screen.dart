import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/widgets/app_page_scaffold.dart';
import 'package:todo/widgets/auth_form_components.dart';

class SessionErrorScreen extends ConsumerStatefulWidget {
  const SessionErrorScreen({super.key});

  @override
  ConsumerState<SessionErrorScreen> createState() => _SessionErrorScreenState();
}

class _SessionErrorScreenState extends ConsumerState<SessionErrorScreen> {
  bool _isRetrying = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPageScaffold(
      title: '',
      showAppearanceActions: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 48),
              const SizedBox(height: 16),
              Text(
                l10n.sessionVerificationError,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              AuthSubmitButton(
                label: l10n.retryButton,
                isLoading: _isRetrying,
                onPressed: _retry,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _retry() async {
    setState(() => _isRetrying = true);
    try {
      await ref.read(authNotifierProvider.notifier).retrySessionRestoration();
    } finally {
      if (mounted) {
        setState(() => _isRetrying = false);
      }
    }
  }
}
