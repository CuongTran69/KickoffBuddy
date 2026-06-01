import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_screen_background.dart';
import '../data/format_guide_repository.dart';
import '../data/format_guide_section.dart';

/// List screen showing format guide section tiles.
///
/// Entry point: Settings > Resources & Reference card.
/// Tapping a tile navigates to [FormatGuideDetailScreen].
class FormatGuideListScreen extends ConsumerWidget {
  const FormatGuideListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsAsync = ref.watch(formatGuideSectionsProvider);
    final l10n = AppLocalizations.of(context);

    return PremiumScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(l10n.formatGuide_appBar_title),
        ),
        body: sectionsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                Text(
                  l10n.formatGuide_error_load,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(formatGuideSectionsProvider),
                  child: Text(l10n.formatGuide_btn_retry),
                ),
              ],
            ),
          ),
          data: (sections) => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                .copyWith(bottom: 100),
            children: sections
                .map((section) => _FormatGuideSectionTile(
                      section: section,
                      onTap: () =>
                          context.push(Routes.formatGuideDetail(section.id)),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _FormatGuideSectionTile extends StatelessWidget {
  const _FormatGuideSectionTile({
    required this.section,
    required this.onTap,
  });

  final FormatGuideSection section;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0x991E293B)
        : const Color(0xD9FFFFFF);
    final borderColor = isDark
        ? const Color(0x3310B981)
        : Colors.white.withValues(alpha: 0.9);
    final activeColor =
        isDark ? const Color(0xFF10B981) : const Color(0xFF059669);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  _iconData(section.icon),
                  color: activeColor,
                  size: 26,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    section.titleVi,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFF1E293B),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconData(String name) {
    switch (name) {
      case 'public':
        return Icons.public;
      case 'groups':
        return Icons.groups;
      case 'trending_up':
        return Icons.trending_up;
      case 'compare_arrows':
        return Icons.compare_arrows;
      case 'format_list_numbered':
        return Icons.format_list_numbered;
      case 'emoji_events':
        return Icons.emoji_events;
      default:
        return Icons.info_outline;
    }
  }
}
