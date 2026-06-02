import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/routing/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_screen_background.dart';
import '../../matches/application/match_mapping.dart';
import '../../matches/application/team_lookup_service.dart';
import '../../matches/data/match.dart';
import '../../matches/presentation/widgets/flag_avatar.dart';
import '../../reminders/presentation/reminder_sheet.dart';
import '../../replay_planner/application/shield_status_provider.dart';
import '../application/next_match_provider.dart';
import '../../../core/network/api_models.dart';
import '../../matches/application/live_match_provider.dart';

/// Home dashboard screen.
///
/// Shows the next upcoming match as a hero card with a live countdown,
/// plus a "Quick Learn" section linking to rule cards.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextMatchAsync = ref.watch(nextMatchProvider);

    return PremiumScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push(Routes.settings),
            ),
          ],
        ),
        body: nextMatchAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(e.toString()),
          ),
          data: (match) => _HomeBody(match: match),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({required this.match});

  final Match? match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final currentMatchesAsync = ref.watch(currentMatchesProvider);
    final todayMatchesAsync = ref.watch(todayMatchesProvider);

    final currentMatches = currentMatchesAsync.valueOrNull ?? [];
    final todayMatches = todayMatchesAsync.valueOrNull ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20), // regular padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DashboardHeader(),
          const _QuickActionsGrid(),
          _SectionHeader(title: l10n.home_section_nextMatch),
          if (currentMatches.isNotEmpty)
            _LiveMatchHeroCard(match: currentMatches.first)
          else if (match != null)
            _NextMatchHeroCard(match: match!)
          else
            _NoMatchHeroCard(),

          const SizedBox(height: 16),

          if (todayMatches.isNotEmpty)
            _TodayMatchesSection(matches: todayMatches),

          _SectionHeader(title: l10n.home_section_quickLearn),
          _QuickLearnSection(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dashboard Header & Quick Actions Grid
// ---------------------------------------------------------------------------

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kickoff Buddy',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Cẩm nang & lịch thi đấu bóng đá tiện ích',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    itemsBuilder(BuildContext context) => [
      _QuickActionItem(
        icon: Icons.calendar_month_outlined,
        label: 'Lịch thi đấu',
        onTap: () {
          final shell = StatefulNavigationShell.of(context);
          shell.goBranch(1);
        },
      ),
      _QuickActionItem(
        icon: Icons.emoji_events_outlined,
        label: 'BXH bảng',
        onTap: () {
          final shell = StatefulNavigationShell.of(context);
          shell.goBranch(2);
        },
      ),
      _QuickActionItem(
        icon: Icons.menu_book_outlined,
        label: 'Cẩm nang luật',
        onTap: () {
          final shell = StatefulNavigationShell.of(context);
          shell.goBranch(3);
        },
      ),
      _QuickActionItem(
        icon: Icons.translate,
        label: 'Từ vựng',
        onTap: () => context.push(Routes.vocabulary),
      ),
      _QuickActionItem(
        icon: Icons.auto_fix_high,
        label: 'Thêm nhanh',
        onTap: () => context.push(Routes.matchesMagicAdd),
      ),
      _QuickActionItem(
        icon: Icons.add_circle_outline,
        label: 'Thêm thủ công',
        onTap: () => context.push(Routes.matchesAdd),
      ),
    ];

    final items = itemsBuilder(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.25,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final itemBgColor = isDark 
        ? AppColors.darkSurfaceVariant
        : AppColors.lightPrimary.withValues(alpha: 0.03);
    
    final borderColor = isDark 
        ? AppColors.darkPrimary.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.03);

    final iconColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Container(
      decoration: BoxDecoration(
        color: itemBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Next Match Hero Card
// ---------------------------------------------------------------------------

class _NextMatchHeroCard extends ConsumerWidget {
  const _NextMatchHeroCard({required this.match});

  final Match match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final teamLookup = ref.watch(teamLookupProvider);

    final teamAVi = teamLookup.viName(match.teamA);
    final teamBVi = teamLookup.viName(match.teamB);
    final teamAIso = teamLookup.isoAlpha2(match.teamA) ?? '';
    final teamBIso = teamLookup.isoAlpha2(match.teamB) ?? '';

    final localKickoff =
        tz.TZDateTime.from(match.kickoffAtUtc.toUtc(), tz.local);
    final dateStr = DateFormat('EEE, d MMM • HH:mm').format(localKickoff);

    final isDark = theme.brightness == Brightness.dark;
    
    final cardBgColor = isDark 
        ? AppColors.darkSurfaceVariant
        : Colors.white;
    
    final borderColor = isDark
        ? AppColors.darkPrimary.withValues(alpha: 0.25)
        : AppColors.lightPrimary.withValues(alpha: 0.2);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : Colors.grey).withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Soccer Pitch Background Markings
              Positioned.fill(
                child: CustomPaint(
                  painter: _SoccerPitchPainter(isDark: isDark),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _HeroTeamColumn(
                            isoAlpha2: teamAIso,
                            name: teamAVi,
                            isDark: isDark,
                          ),
                        ),
                        _CountdownPill(kickoffAtUtc: match.kickoffAtUtc),
                        Expanded(
                          child: _HeroTeamColumn(
                            isoAlpha2: teamBIso,
                            name: teamBVi,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Date / venue line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          match.venueCity != null
                              ? '$dateStr • ${match.venueCity}'
                              : dateStr,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Action buttons with glass-like/outlined styles
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            icon: const Icon(Icons.notifications_outlined, size: 16),
                            label: Text(l10n.home_btn_setReminder),
                            style: FilledButton.styleFrom(
                              foregroundColor: isDark ? Colors.white : AppColors.lightPrimary,
                              backgroundColor: isDark 
                                  ? Colors.white.withValues(alpha: 0.08) 
                                  : AppColors.lightPrimary.withValues(alpha: 0.08),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => showReminderSheet(context, match),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            icon: const Icon(Icons.arrow_forward, size: 16),
                            label: Text(l10n.home_btn_viewDetail),
                            style: FilledButton.styleFrom(
                              backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () =>
                                context.push(Routes.matchDetail(match.matchId)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroTeamColumn extends StatelessWidget {
  const _HeroTeamColumn({
    required this.isoAlpha2,
    required this.name,
    required this.isDark,
  });

  final String isoAlpha2;
  final String name;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.darkPrimary.withValues(alpha: 0.3) : AppColors.lightPrimary.withValues(alpha: 0.3),
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    .withValues(alpha: 0.25),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: FlagAvatar(
            isoAlpha2: isoAlpha2,
            size: 64,
            isCircle: true,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 130),
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Countdown pill with 60s periodic refresh & pulsing Live dot
// ---------------------------------------------------------------------------

class _CountdownPill extends ConsumerWidget {
  const _CountdownPill({required this.kickoffAtUtc});

  final DateTime kickoffAtUtc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Reuse the 60s clock from shield_status_provider.
    final clockAsync = ref.watch(shieldClockProvider);
    final now = clockAsync.valueOrNull ?? DateTime.now();

    final remaining = kickoffAtUtc.toUtc().difference(now.toUtc());
    final countdownText = _formatCountdown(remaining, l10n);

    final accentColor =
        isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final accentBg = accentColor.withValues(alpha: 0.12);

    final isLiveSoon = remaining.isNegative || remaining.inMinutes < 15;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accentBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.15),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulsingDot(color: isLiveSoon ? (isDark ? AppColors.darkError : AppColors.lightError) : accentColor),
          const SizedBox(width: 6),
          Text(
            countdownText,
            style: AppTypography.tabularNumbers(
              fontSize: 12,
              color: accentColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatCountdown(Duration remaining, AppLocalizations l10n) {
    if (remaining.isNegative || remaining.inSeconds < 60) {
      return l10n.home_countdown_soon;
    }
    if (remaining.inHours >= 24) {
      final days = remaining.inDays;
      final hours = remaining.inHours - days * 24;
      return l10n.home_countdown_days(days, hours);
    }
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes - hours * 60;
    return l10n.home_countdown_hours(hours, minutes);
  }
}

// ---------------------------------------------------------------------------
// No-match empty hero
// ---------------------------------------------------------------------------

class _NoMatchHeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.lightSurfaceVariant;
    final borderColor = isDark
        ? AppColors.darkSurfaceContainerHigh
        : AppColors.lightSurfaceContainerHigh;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.sports_soccer,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.home_hero_noMatch_title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(Routes.matches),
              child: Text(l10n.home_hero_noMatch_cta),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick Learn section - Premium Carousel
// ---------------------------------------------------------------------------

class _QuickLearnSection extends StatelessWidget {
  static const _quickLearnIds = [
    'offside_newbie',
    'penalty_newbie',
    'var_newbie',
    'vocabulary',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: _quickLearnIds.length,
        itemBuilder: (context, index) {
          return _QuickLearnCard(ruleId: _quickLearnIds[index]);
        },
      ),
    );
  }
}

class _QuickLearnCard extends StatelessWidget {
  const _QuickLearnCard({required this.ruleId});

  final String ruleId;

  static const _labels = {
    'offside_newbie': 'Việt vị',
    'penalty_newbie': 'Phạt đền',
    'var_newbie': 'VAR',
    'vocabulary': 'Từ vựng',
  };

  static const _descriptions = {
    'offside_newbie': 'Luật việt vị cơ bản cho người mới bắt đầu.',
    'penalty_newbie': 'Tìm hiểu khi nào phạt đền xảy ra.',
    'var_newbie': 'VAR hoạt động như thế nào trong trận?',
    'vocabulary': 'Tra cứu các thuật ngữ bóng đá thông dụng.',
  };

  static const _icons = {
    'offside_newbie': Icons.sports,
    'penalty_newbie': Icons.sports_soccer,
    'var_newbie': Icons.tv,
    'vocabulary': Icons.translate,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = _labels[ruleId] ?? ruleId;
    final desc = _descriptions[ruleId] ?? '';
    final icon = _icons[ruleId] ?? Icons.menu_book_outlined;
    final isDark = theme.brightness == Brightness.dark;

    final cardBgColor = isDark 
        ? AppColors.darkSurfaceVariant
        : Colors.white.withValues(alpha: 0.95);

    final borderColor = isDark 
        ? AppColors.darkPrimary.withValues(alpha: 0.3)
        : AppColors.lightPrimary.withValues(alpha: 0.3);

    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (ruleId == 'vocabulary') {
                context.push(Routes.vocabulary);
              } else {
                context.push(Routes.ruleDetail(ruleId));
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        icon,
                        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        size: 24,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        desc,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Soccer Pitch Background Painter
// ---------------------------------------------------------------------------

class _SoccerPitchPainter extends CustomPainter {
  const _SoccerPitchPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.05 : 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw center circle
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 36, paint);

    // Draw center line
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    // Draw outer boundary with a padding
    const padding = 6.0;
    canvas.drawRect(
      Rect.fromLTWH(padding, padding, size.width - padding * 2, size.height - padding * 2),
      paint,
    );

    // Draw penalty areas on left and right
    final penaltyBoxWidth = size.width * 0.16;
    final penaltyBoxHeight = size.height * 0.55;
    
    // Left penalty box
    canvas.drawRect(
      Rect.fromLTWH(
        padding,
        (size.height - penaltyBoxHeight) / 2,
        penaltyBoxWidth,
        penaltyBoxHeight,
      ),
      paint,
    );

    // Right penalty box
    canvas.drawRect(
      Rect.fromLTWH(
        size.width - padding - penaltyBoxWidth,
        (size.height - penaltyBoxHeight) / 2,
        penaltyBoxWidth,
        penaltyBoxHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Pulsing Live Indicator Dot
// ---------------------------------------------------------------------------

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});

  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.5),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveMatchHeroCard extends ConsumerWidget {
  const _LiveMatchHeroCard({required this.match});

  final ApiMatch match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final teamLookup = ref.watch(teamLookupProvider);
    final allLocalsAsync = ref.watch(allLocalMatchesProvider);

    final teamAVi = teamLookup.viName(match.homeTeam.name);
    final teamBVi = teamLookup.viName(match.awayTeam.name);
    final teamAIso = teamLookup.isoAlpha2(match.homeTeam.name) ?? '';
    final teamBIso = teamLookup.isoAlpha2(match.awayTeam.name) ?? '';

    final isDark = theme.brightness == Brightness.dark;

    final cardBgColor = isDark 
        ? AppColors.darkSurfaceVariant
        : const Color(0xFFFEF2F2); // Red-50 tint for light mode live match
    
    final borderColor = isDark
        ? AppColors.darkError.withValues(alpha: 0.3)
        : AppColors.lightError.withValues(alpha: 0.25);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : Colors.grey).withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _SoccerPitchPainter(isDark: isDark),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // LIVE indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFFDC2626) : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? const Color(0xFFEF4444) : const Color(0xFFF87171),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _PulsingDot(color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            l10n.home_live_indicator,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isDark ? Colors.white : const Color(0xFFDC2626),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Teams and Score row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: _HeroTeamColumn(
                            isoAlpha2: teamAIso,
                            name: teamAVi,
                            isDark: isDark,
                          ),
                        ),
                        // Live Score display
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '${match.homeTeam.goals} – ${match.awayTeam.goals}',
                            style: AppTypography.tabularNumbers(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : AppColors.lightOnSurface,
                            ),
                          ),
                        ),
                        Flexible(
                          child: _HeroTeamColumn(
                            isoAlpha2: teamBIso,
                            name: teamBVi,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Venue / Stage info
                    Text(
                      '${match.stageName} • ${match.venue}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: Text(l10n.home_live_viewDetail),
                        style: FilledButton.styleFrom(
                          backgroundColor: isDark ? AppColors.darkError : AppColors.lightError,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final locals = allLocalsAsync.valueOrNull ?? [];
                          final local = findLocalMatchFor(match, locals);
                          if (local != null) {
                            context.push(Routes.matchDetail(local.matchId));
                          }
                          // If unresolved, no-op — do not navigate to NotFound.
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayMatchesSection extends StatelessWidget {
  const _TodayMatchesSection({required this.matches});

  final List<ApiMatch> matches;

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.home_today_sectionHeader),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: matches.length,
            itemBuilder: (context, index) {
              return _TodayMatchCard(match: matches[index]);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _TodayMatchCard extends ConsumerWidget {
  const _TodayMatchCard({required this.match});

  final ApiMatch match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final teamLookup = ref.watch(teamLookupProvider);
    final isDark = theme.brightness == Brightness.dark;
    final allLocalsAsync = ref.watch(allLocalMatchesProvider);

    final teamAVi = teamLookup.viName(match.homeTeam.name);
    final teamBVi = teamLookup.viName(match.awayTeam.name);
    final teamAIso = teamLookup.isoAlpha2(match.homeTeam.name) ?? '';
    final teamBIso = teamLookup.isoAlpha2(match.awayTeam.name) ?? '';

    final localKickoff = tz.TZDateTime.from(match.datetime.toUtc(), tz.local);
    final timeStr = DateFormat('HH:mm').format(localKickoff);

    final cardBgColor = isDark
        ? const Color(0x991E293B) // Slate-800 with 60% opacity
        : const Color(0xD9FFFFFF); // White with 85% opacity
    final borderColor = isDark 
        ? AppColors.darkPrimary.withValues(alpha: 0.3) 
        : AppColors.lightPrimary.withValues(alpha: 0.3);

    final textMuted = isDark ? AppColors.darkOnSurfaceMuted : AppColors.lightOnSurfaceMuted;

    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            final locals = allLocalsAsync.valueOrNull ?? [];
            final local = findLocalMatchFor(match, locals);
            if (local != null) {
              context.push(Routes.matchDetail(local.matchId));
            }
            // If unresolved, no-op — do not navigate to NotFound.
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        match.stageName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: textMuted,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusPill(context, match, timeStr),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FlagAvatar(isoAlpha2: teamAIso, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        teamAVi,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (match.status != 'future_scheduled')
                      Text(
                        '${match.homeTeam.goals}',
                        style: AppTypography.tabularNumbers(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FlagAvatar(isoAlpha2: teamBIso, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        teamBVi,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (match.status != 'future_scheduled')
                      Text(
                        '${match.awayTeam.goals}',
                        style: AppTypography.tabularNumbers(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPill(BuildContext context, ApiMatch match, String timeStr) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (match.status == 'in_progress') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isDark ? const Color(0x33DC2626) : const Color(0x1FDC2626),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PulsingDot(color: Colors.red),
            SizedBox(width: 4),
            Text(
              'LIVE',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (match.status == 'completed') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isDark ? const Color(0x2694A3B8) : const Color(0x1F64748B),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'FT',
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.darkOnSurfaceMuted : AppColors.lightOnSurfaceMuted,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Text(
      timeStr,
      style: theme.textTheme.bodySmall?.copyWith(
        color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
