import 'package:flutter/material.dart';
import 'package:todo/l10n/app_localizations.dart';

class NavigationBarDestinationData {
  const NavigationBarDestinationData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

List<NavigationBarDestinationData> navigationBarDestinations(
  BuildContext context,
) {
  final l10n = AppLocalizations.of(context)!;
  return [
    NavigationBarDestinationData(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: l10n.navHome,
    ),
    NavigationBarDestinationData(
      icon: Icons.call_outlined,
      activeIcon: Icons.call_rounded,
      label: l10n.navCalls,
    ),
    NavigationBarDestinationData(
      icon: Icons.music_note_outlined,
      activeIcon: Icons.music_note_rounded,
      label: l10n.navMusic,
    ),
    NavigationBarDestinationData(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: l10n.navProfile,
    ),
  ];
}
