import 'package:flutter/material.dart';
import 'package:todo/widgets/glass_box.dart';
import 'package:todo/widgets/navigation_bar_destination.dart';
import 'package:todo/widgets/navigation_bar_item.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final destinations = navigationBarDestinations(context);
    final selectedIndex = currentIndex.clamp(0, destinations.length - 1);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerColor = isDark ? Colors.black : Colors.white;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.14),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: GlassBox(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            opacity: isDark ? 0.35 : 0.75,
            blur: 20,
            borderRadius: BorderRadius.circular(32),
            color: containerColor,
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.1),
              width: 1.5,
            ),
            child: Row(
              children: [
                for (var index = 0; index < destinations.length; index++)
                  Expanded(
                    child: NavigationBarItem(
                      destination: destinations[index],
                      selected: selectedIndex == index,
                      isDark: isDark,
                      onTap: () => onTap(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
