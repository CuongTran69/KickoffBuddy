## 1. i18n Strings

- [x] 1.1 Add Sleep Plan strings to `app/lib/l10n/app_en.arb`: `sleepPlan_cardTitle`, `sleepPlan_disclaimer`, `sleepPlan_mode_lateWatcher_title`, `sleepPlan_mode_lateWatcher_body`, `sleepPlan_mode_balanced_title`, `sleepPlan_mode_balanced_body`, `sleepPlan_mode_healthyReplay_title`, `sleepPlan_mode_healthyReplay_body`, `sleepPlan_mode_healthyReplay_cta`
- [x] 1.2 Add matching strings to `app/lib/l10n/app_vi.arb` ← (verify: all 9 keys present in both ARB files, no missing keys)

## 2. SleepPlanCard Widget

- [x] 2.1 Create `app/lib/features/matches/presentation/widgets/sleep_plan_card.dart` with a stateless `SleepPlanCard` widget that accepts a `Match match` parameter
- [x] 2.2 Implement the card using the glassmorphism style from `_PremiumSettingsCard` in `settings_screen.dart` (translucent background, rounded corners 20, emerald border, `Icons.bedtime_outlined` header icon)
- [x] 2.3 Render three mode rows: Late Watcher, Balanced, Healthy Replay — each with title + body text from l10n
- [x] 2.4 Add a "Set up Replay Planner" `OutlinedButton` in the Healthy Replay row that calls `showReplayPlannerDialog(context, match)`
- [x] 2.5 Add the disclaimer text at the bottom of the card using `theme.textTheme.bodySmall` with muted color ← (verify: card renders all three modes, CTA button present, disclaimer visible, styling matches design system)

## 3. Match Detail Integration

- [x] 3.1 In `app/lib/features/matches/presentation/match_detail_screen.dart`, import `sleep_plan_card.dart`
- [x] 3.2 Add trigger logic: compute `isLateNight = localKickoff.hour >= 22 || localKickoff.hour < 5`
- [x] 3.3 Insert `if (isLateNight && !isKickedOff) SleepPlanCard(match: match)` followed by `const SizedBox(height: 16)` between the match info card and the "My Matches" `FilledButton.icon` ← (verify: card appears for 22:00–04:59 kickoffs not yet started; card absent for daytime matches and past matches; no layout regression on existing elements)

## 4. Analysis Check

- [x] 4.1 Run `flutter analyze --no-fatal-infos` from `app/` and confirm no errors in modified files ← (verify: zero analysis errors in sleep_plan_card.dart and match_detail_screen.dart)
