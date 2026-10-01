import 'package:todo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:todo/widgets/empty_section_screen.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptySectionScreen(
      title: l10n.navMusic,
      emptyTitle: l10n.navMusic,
      emptySubtitle: l10n.emptyStateSubtitle,
      icon: Icons.music_note_outlined,
    );
  }
}
