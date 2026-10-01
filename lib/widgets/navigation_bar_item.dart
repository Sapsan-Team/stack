import 'package:flutter/material.dart';
import 'package:todo/widgets/navigation_bar_destination.dart';

class NavigationBarItem extends StatelessWidget {
  const NavigationBarItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final NavigationBarDestinationData destination;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Tooltip(
      message: destination.label,
      child: Semantics(
        button: true,
        selected: selected,
        label: destination.label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? primaryColor.withValues(alpha: 0.16)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                selected ? destination.activeIcon : destination.icon,
                size: 24,
                color: selected
                    ? primaryColor
                    : (isDark ? Colors.white54 : Colors.black38),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
