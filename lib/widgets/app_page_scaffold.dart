import 'package:flutter/material.dart';
import 'package:todo/widgets/locale_button.dart';
import 'package:todo/widgets/theme_button.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.showAppearanceActions = true,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final bool showAppearanceActions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title.isEmpty ? null : Text(title),
        actions: [
          if (showAppearanceActions) ...const [LocaleButton(), ThemeButton()],
          ...actions,
        ],
      ),
      body: body,
    );
  }
}
