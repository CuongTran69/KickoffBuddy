import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_screen_background.dart';
import '../data/etiquette_repository.dart';
import '../data/etiquette_tip.dart';

/// List screen showing 7 fan etiquette tip tiles.
///
/// Entry point: Settings > Resources & Reference card.
/// Tapping a tile navigates to [EtiquetteDetailScreen].
class EtiquetteListScreen extends ConsumerWidget {
  const EtiquetteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipsAsync = ref.watch(etiquetteTipsProvider);
    final l10n = AppLocalizations.of(context);

    return PremiumScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(l10n.etiquette_appBar_title),
        ),
        body: tipsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                Text(
                  l10n.etiquette_error_load,
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
                  onPressed: () => ref.invalidate(etiquetteTipsProvider),
                  child: Text(l10n.etiquette_btn_retry),
                ),
              ],
            ),
          ),
          data: (tips) => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                .copyWith(bottom: 100),
            children: tips
                .map((tip) => _EtiquetteTipTile(
                      tip: tip,
                      onTap: () =>
                          context.push(Routes.etiquetteDetail(tip.id)),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _EtiquetteTipTile extends StatelessWidget {
  const _EtiquetteTipTile({
    required this.tip,
    required this.onTap,
  });

  final EtiquetteTip tip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0x991E293B)
        : const Color(0xD9FFFFFF);
    final borderColor = isDark
        ? AppColors.darkPrimary.withValues(alpha: 0.2)
        : Colors.white.withValues(alpha: 0.9);
    final activeColor =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

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
                  _iconData(tip.icon),
                  color: activeColor,
                  size: 26,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    tip.titleVi,
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
      case 'block':
        return Icons.block;
      case 'groups':
        return Icons.groups;
      case 'school':
        return Icons.school;
      case 'local_bar':
        return Icons.local_bar;
      case 'celebration':
        return Icons.celebration;
      case 'sports':
        return Icons.sports;
      case 'timer':
        return Icons.timer;
      default:
        return Icons.info_outline;
    }
  }
}
