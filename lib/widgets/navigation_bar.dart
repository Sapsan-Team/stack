import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/theme/app_colors.dart';
import 'package:todo/theme/spacing.dart';
import 'package:todo/theme/text_styles.dart';
import 'package:todo/widgets/glass_box.dart';

class BottomNavBar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authNotifierProvider);
    final isAdmin = user?.username == 'admin';

    final items = navBarItems(context, isAdmin: isAdmin);
    final blueDim = AppColors.primaryBlue.withValues(alpha: 0.15);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Spacing.xl,
          0,
          Spacing.xl,
          Spacing.xl,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: blueDim,
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: GlassBox(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            opacity: isDark ? 0.35 : 0.75,
            blur: 20,
            borderRadius: BorderRadius.circular(32),
            color: isDark ? Colors.black : Colors.white,
            border: Border.all(
              color: AppColors.primaryBlue.withValues(
                alpha: isDark ? 0.15 : 0.1,
              ),
              width: 1.5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = currentIndex == index;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? blueDim : Colors.transparent,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          size: 24,
                          color: isSelected
                              ? AppColors.primaryBlue
                              : (isDark ? Colors.white54 : Colors.black38),
                        ),
                        if (isSelected && item.label != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            item.label!,
                            style: ThemeTextStyles.caption(isDark: isDark)
                                .copyWith(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class NavBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String? label;

  NavBarItem({required this.icon, required this.activeIcon, this.label});
}

List<NavBarItem> navBarItems(BuildContext context, {bool isAdmin = false}) => [
  NavBarItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: AppLocalizations.of(context)!.home,
  ),
  NavBarItem(
    icon: Icons.menu_book_outlined,
    activeIcon: Icons.menu_book_rounded,
    label: AppLocalizations.of(context)!.materials,
  ),
  if (!isAdmin)
    NavBarItem(
      icon: Icons.collections_bookmark_outlined,
      activeIcon: Icons.collections_bookmark_rounded,
      label: AppLocalizations.of(context)!.my_vocabulary,
    ),
  NavBarItem(
    icon: Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
    label: AppLocalizations.of(context)!.profile,
  ),
];
