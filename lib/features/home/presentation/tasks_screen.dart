import 'package:flutter/material.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/widgets/empty_state.dart';
import 'package:todo/widgets/locale_button.dart';
import 'package:todo/widgets/theme_button.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navTasks),
        actions: const [
          LocaleButton(),
          ThemeButton(),
        ],
      ),
      body: SafeArea(
        child: EmptyState(
          title: l10n.navTasks,
          subtitle: l10n.emptyStateSubtitle,
          icon: Icons.assignment_outlined,
        ),
      ),
    );
  }
}
