import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/storage/prefs_provider.dart';
import '../../../features/matches/data/match.dart';
import '../../../l10n/app_localizations.dart';
import '../application/reminder_controller.dart';
import '../application/reminder_scheduler.dart';
import 'widgets/reminder_offset_chip.dart';

const _kPermissionKey = 'notification_permission_decision';
const _kPermissionGranted = 'granted';
const _kPermissionDenied = 'denied';

/// Entry point: checks permission then shows the reminder bottom sheet.
///
/// Permission flow (D1):
/// - null → request OS prompt; persist result; open sheet or show dialog.
/// - granted → open sheet directly.
/// - denied → show explanatory dialog with "Open Settings" deep link.
Future<void> showReminderSheet(BuildContext context, Match match) async {
  final prefs = ProviderScope.containerOf(context).read(sharedPreferencesProvider);
  final notifService =
      ProviderScope.containerOf(context).read(notificationServiceProvider);

  final decision = prefs.getString(_kPermissionKey);

  if (decision == _kPermissionGranted) {
    // Already granted — check exact alarm permission on Android 12+ (D1).
    if (context.mounted) {
      final canSchedule = await notifService.canScheduleExactAlarms();
      if (!context.mounted) return;
      if (!canSchedule) {
        await _showExactAlarmDialog(context);
        return;
      }
      await _openSheet(context, match);
    }
    return;
  }

  if (decision == _kPermissionDenied) {
    // Previously denied — show explanatory dialog.
    if (context.mounted) {
      await _showPermissionDeniedDialog(context);
    }
    return;
  }

  // First time — request OS permission.
  final granted = await notifService.requestPermissions();
  await prefs.setString(
    _kPermissionKey,
    granted ? _kPermissionGranted : _kPermissionDenied,
  );

  if (!context.mounted) return;

  if (granted) {
    // Check exact alarm permission on Android 12+ before opening sheet (D1).
    final canSchedule = await notifService.canScheduleExactAlarms();
    if (!context.mounted) return;
    if (!canSchedule) {
      await _showExactAlarmDialog(context);
    } else {
      await _openSheet(context, match);
    }
  } else {
    await _showPermissionDeniedDialog(context);
  }
}

Future<void> _openSheet(BuildContext context, Match match) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _ReminderSheetContent(match: match),
  );
}

Future<void> _showPermissionDeniedDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.reminder_permission_title),
      content: Text(l10n.reminder_permission_body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.common_btn_cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(ctx);
            AppSettings.openAppSettings(type: AppSettingsType.notification);
          },
          child: Text(l10n.reminder_permission_openSettings),
        ),
      ],
    ),
  );
}

/// Shows a rationale dialog when exact alarm permission is not granted
/// on Android 12+. Deep-links to the system exact alarm settings page.
Future<void> _showExactAlarmDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.reminder_exactAlarm_title),
      content: Text(l10n.reminder_exactAlarm_body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.common_btn_cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(ctx);
            // Deep-link to ACTION_REQUEST_SCHEDULE_EXACT_ALARM on Android 12+.
            // AppSettingsType.alarm maps to ACTION_REQUEST_SCHEDULE_EXACT_ALARM
            // on Android, which opens the dedicated exact-alarm settings page.
            if (defaultTargetPlatform == TargetPlatform.android) {
              AppSettings.openAppSettings(type: AppSettingsType.alarm);
            }
          },
          child: Text(l10n.reminder_exactAlarm_openSettings),
        ),
      ],
    ),
  );
}

/// The actual bottom sheet content widget.
class _ReminderSheetContent extends ConsumerWidget {
  const _ReminderSheetContent({required this.match});

  final Match match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reminderControllerProvider(match.matchId));
    final controller =
        ref.read(reminderControllerProvider(match.matchId).notifier);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.reminder_sheet_title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kReminderOffsets.map((offset) {
              return ReminderOffsetChip(
                offsetMinutes: offset,
                selected: state.selectedOffsets.contains(offset),
                onTap: () => controller.toggleOffset(offset),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.reminder_btn_cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => _save(context, ref, l10n),
                  child: Text(l10n.reminder_btn_save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final controller =
        ref.read(reminderControllerProvider(match.matchId).notifier);
    final result = await controller.save(match.matchId);

    if (!context.mounted) return;
    Navigator.pop(context);

    if (result.scheduled.isEmpty && result.skipped.isEmpty) {
      // No offsets selected — cleared.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.reminder_snackbar_cleared)),
      );
    } else if (result.skipped.isNotEmpty) {
      final skippedLabels =
          result.skipped.map(offsetLabel).join(', ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.reminder_snackbar_skipped(skippedLabels)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.reminder_snackbar_saved)),
      );
    }
  }
}
