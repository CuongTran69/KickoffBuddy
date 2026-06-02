import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_screen_background.dart';
import '../application/settings_providers.dart';

/// Screen allowing the user to configure app language and theme mode.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return PremiumScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
              child: Text(
                l10n.settings_appBar_title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            // Theme Section Card
            _PremiumSettingsCard(
              title: l10n.settings_themeMode,
              icon: Icons.palette_outlined,
              child: Row(
                children: [
                  _ThemeSelectorItem(
                    mode: ThemeMode.light,
                    label: l10n.settings_theme_light,
                    icon: Icons.light_mode_outlined,
                    isSelected: themeMode == ThemeMode.light,
                    onTap: () {
                      ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
                    },
                  ),
                  const SizedBox(width: 8),
                  _ThemeSelectorItem(
                    mode: ThemeMode.dark,
                    label: l10n.settings_theme_dark,
                    icon: Icons.dark_mode_outlined,
                    isSelected: themeMode == ThemeMode.dark,
                    onTap: () {
                      ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
                    },
                  ),
                  const SizedBox(width: 8),
                  _ThemeSelectorItem(
                    mode: ThemeMode.system,
                    label: l10n.settings_theme_system,
                    icon: Icons.settings_suggest_outlined,
                    isSelected: themeMode == ThemeMode.system,
                    onTap: () {
                      ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Language Section Card
            _PremiumSettingsCard(
              title: l10n.settings_language,
              icon: Icons.language_outlined,
              child: Column(
                children: [
                  _LanguageSelectorTile(
                    label: l10n.settings_language_vi,
                    flag: '🇻🇳',
                    isSelected: locale?.languageCode == 'vi',
                    onTap: () {
                      ref.read(localeProvider.notifier).setLocale(const Locale('vi'));
                    },
                  ),
                  const SizedBox(height: 10),
                  _LanguageSelectorTile(
                    label: l10n.settings_language_en,
                    flag: '🇬🇧',
                    isSelected: locale?.languageCode == 'en',
                    onTap: () {
                      ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Resources Section Card
            _PremiumSettingsCard(
              title: locale?.languageCode == 'vi' ? 'Tài nguyên & Tra cứu' : 'Resources & Reference',
              icon: Icons.menu_book_outlined,
              child: Column(
                children: [
                  _SettingsNavigationTile(
                    label: l10n.vocabulary_appBar_title,
                    icon: Icons.translate,
                    onTap: () {
                      context.push(Routes.vocabulary);
                    },
                  ),
                  const SizedBox(height: 10),
                  _SettingsNavigationTile(
                    label: l10n.etiquette_appBar_title,
                    icon: Icons.sports_soccer,
                    onTap: () {
                      context.push(Routes.etiquette);
                    },
                  ),
                  const SizedBox(height: 10),
                  _SettingsNavigationTile(
                    label: l10n.formatGuide_appBar_title,
                    icon: Icons.emoji_events_outlined,
                    onTap: () {
                      context.push(Routes.formatGuide);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // About / Disclaimer Card (D4)
            _PremiumSettingsCard(
              title: l10n.settings_about_title,
              icon: Icons.info_outline,
              child: Text(
                l10n.settings_about_disclaimer,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumSettingsCard extends StatelessWidget {
  const _PremiumSettingsCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0x991E293B) // Slate-800 with 60% opacity
        : const Color(0xD9FFFFFF); // White with 85% opacity
    final borderColor = isDark
        ? AppColors.darkPrimary.withValues(alpha: 0.2)
        : Colors.white.withValues(alpha: 0.9);
    final double borderWidth = isDark ? 1.0 : 1.5;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : AppColors.lightPrimary.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _ThemeSelectorItem extends StatelessWidget {
  const _ThemeSelectorItem({
    required this.mode,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final ThemeMode mode;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activeColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final inactiveColor = isDark ? AppColors.darkOnSurfaceMuted : const Color(0xFF64748B);

    final itemBgColor = isSelected
        ? (isDark ? AppColors.darkPrimary.withValues(alpha: 0.1) : AppColors.lightPrimary.withValues(alpha: 0.06))
        : (isDark ? const Color(0x0AFFFFFF) : Colors.white.withValues(alpha: 0.45));

    final itemBorderColor = isSelected
        ? activeColor.withValues(alpha: 0.5)
        : (isDark ? const Color(0x2694A3B8) : Colors.white.withValues(alpha: 0.6));

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: itemBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: itemBorderColor,
              width: 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 22,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected ? activeColor : inactiveColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSelectorTile extends StatelessWidget {
  const _LanguageSelectorTile({
    required this.label,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activeColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final tileBgColor = isSelected
        ? (isDark ? AppColors.darkPrimary.withValues(alpha: 0.1) : AppColors.lightPrimary.withValues(alpha: 0.06))
        : (isDark ? const Color(0x0AFFFFFF) : Colors.white.withValues(alpha: 0.45));
    final tileBorderColor = isSelected
        ? activeColor.withValues(alpha: 0.5)
        : (isDark ? const Color(0x2694A3B8) : Colors.white.withValues(alpha: 0.6));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: tileBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: tileBorderColor,
            width: 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Text(
                flag,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? (isDark ? Colors.white : Colors.black)
                        : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: activeColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsNavigationTile extends StatelessWidget {
  const _SettingsNavigationTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activeColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final tileBgColor = isDark ? const Color(0x0AFFFFFF) : Colors.white.withValues(alpha: 0.45);
    final tileBorderColor = isDark ? const Color(0x2694A3B8) : Colors.white.withValues(alpha: 0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: tileBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: tileBorderColor,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                color: activeColor,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
