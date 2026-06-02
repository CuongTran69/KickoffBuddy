import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/premium_screen_background.dart';
import '../theme/app_colors.dart';

/// Shell scaffold that wraps the four primary tab destinations.
///
/// Uses [StatefulShellRoute.indexedStack] so each tab's navigation stack
/// and scroll position are preserved when switching tabs.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isVi = Localizations.localeOf(context).languageCode == 'vi';

    final destinations = [
      _NavBarDestination(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: l10n.nav_home,
      ),
      _NavBarDestination(
        icon: Icons.calendar_month_outlined,
        selectedIcon: Icons.calendar_month,
        label: l10n.nav_matches,
      ),
      _NavBarDestination(
        icon: Icons.emoji_events_outlined,
        selectedIcon: Icons.emoji_events,
        label: isVi ? 'BXH' : l10n.nav_standings,
      ),
      _NavBarDestination(
        icon: Icons.menu_book_outlined,
        selectedIcon: Icons.menu_book,
        label: l10n.nav_rules,
      ),
    ];

    return PremiumScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: false,
        body: navigationShell,
      bottomNavigationBar: _PremiumFloatingNavBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            // Return to the initial location of the branch if already on it.
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: destinations,
      ),
    ),
    );
  }
}

class _PremiumFloatingNavBar extends StatelessWidget {
  const _PremiumFloatingNavBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<_NavBarDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xBF0F172A) // Slate-900 with ~75% opacity
        : const Color(0xD9FFFFFF); // White with ~85% opacity
    final borderColor = isDark
        ? const Color(0x33334155) // Slate-700 with opacity
        : const Color(0x33CBD5E1); // Slate-300 with opacity
    final shadowColor = Colors.black.withValues(alpha: isDark ? 0.35 : 0.08);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: borderColor,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: List.generate(destinations.length, (index) {
                    final dest = destinations[index];
                    final isSelected = selectedIndex == index;

                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (!isSelected) {
                            HapticFeedback.lightImpact();
                          }
                          onDestinationSelected(index);
                        },
                        child: _NavBarItem(
                          destination: dest,
                          isSelected: isSelected,
                          theme: theme,
                          isDark: isDark,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.destination,
    required this.isSelected,
    required this.theme,
    required this.isDark,
  });

  final _NavBarDestination destination;
  final bool isSelected;
  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final inactiveColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedScale(
          scale: isSelected ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isSelected ? destination.selectedIcon : destination.icon,
            color: isSelected ? activeColor : inactiveColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          destination.label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isSelected ? activeColor : inactiveColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 10,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _NavBarDestination {
  const _NavBarDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
