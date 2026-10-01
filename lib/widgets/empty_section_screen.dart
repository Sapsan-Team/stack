import 'package:flutter/material.dart';
import 'package:todo/widgets/app_page_scaffold.dart';
import 'package:todo/widgets/empty_state.dart';

class EmptySectionScreen extends StatelessWidget {
  const EmptySectionScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  final String title;
  final IconData icon;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: title,
      body: EmptyState(
        title: emptyTitle,
        subtitle: emptySubtitle,
        icon: icon,
      ),
    );
  }
}
