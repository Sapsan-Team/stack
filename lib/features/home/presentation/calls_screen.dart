import 'package:todo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:todo/widgets/empty_section_screen.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptySectionScreen(
      title: l10n.navCalls,
      emptyTitle: l10n.navCalls,
      emptySubtitle: l10n.emptyStateSubtitle,
      icon: Icons.call_outlined,
    );
  }
}
