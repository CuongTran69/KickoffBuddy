import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../features/matches/data/match.dart';
import '../../../l10n/app_localizations.dart';
import '../application/replay_planner_controller.dart';

/// Opens the replay planner dialog for [match].
///
/// Handles both "plan new replay" and "cancel existing plan" flows.
Future<void> showReplayPlannerDialog(
  BuildContext context,
  Match match,
) async {
  await showDialog<void>(
    context: context,
    builder: (ctx) => _ReplayPlannerDialog(match: match),
  );
}

class _ReplayPlannerDialog extends ConsumerStatefulWidget {
  const _ReplayPlannerDialog({required this.match});

  final Match match;

  @override
  ConsumerState<_ReplayPlannerDialog> createState() =>
      _ReplayPlannerDialogState();
}

class _ReplayPlannerDialogState
    extends ConsumerState<_ReplayPlannerDialog> {
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;
  String? _validationError;

  Match get match => widget.match;

  tz.TZDateTime? get _pickedDateTime {
    if (_pickedDate == null || _pickedTime == null) return null;
    return tz.TZDateTime(
      tz.local,
      _pickedDate!.year,
      _pickedDate!.month,
      _pickedDate!.day,
      _pickedTime!.hour,
      _pickedTime!.minute,
    );
  }

  bool get _canSave {
    if (_pickedDateTime == null) return false;
    return _validationError == null;
  }

  void _validate(AppLocalizations l10n) {
    final dt = _pickedDateTime;
    if (dt == null) {
      setState(() => _validationError = null);
      return;
    }

    final now = DateTime.now();
    final kickoffLocal = tz.TZDateTime.from(
      match.kickoffAtUtc.toUtc(),
      tz.local,
    );

    if (!dt.isAfter(kickoffLocal)) {
      setState(
          () => _validationError = l10n.replayPlanner_validation_mustBeAfterKickoff);
      return;
    }
    if (!dt.isAfter(now)) {
      setState(
          () => _validationError = l10n.replayPlanner_validation_mustBeInFuture);
      return;
    }
    setState(() => _validationError = null);
  }

  Future<void> _pickDate(AppLocalizations l10n) async {
    final now = DateTime.now();
    final kickoffLocal = tz.TZDateTime.from(
      match.kickoffAtUtc.toUtc(),
      tz.local,
    );
    // firstDate = max(today, kickoffDate)
    final firstDate = now.isAfter(kickoffLocal) ? now : kickoffLocal;

    final picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? firstDate,
      firstDate: DateTime(
        firstDate.year,
        firstDate.month,
        firstDate.day,
      ),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _pickedDate = picked);
      _validate(l10n);
    }
  }

  Future<void> _pickTime(AppLocalizations l10n) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _pickedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _pickedTime = picked);
      _validate(l10n);
    }
  }

  Future<void> _save(AppLocalizations l10n) async {
    final dt = _pickedDateTime;
    if (dt == null) return;

    final controller = ref.read(
      replayPlannerControllerProvider(match.matchId).notifier,
    );

    try {
      await controller.savePlan(match, dt);
    } catch (e) {
      if (mounted) {
        setState(() => _validationError = e.toString());
      }
      return;
    }

    if (!mounted) return;
    Navigator.pop(context);

    final localDt = tz.TZDateTime.from(dt.toUtc(), tz.local);
    final formatted = DateFormat('EEE, HH:mm').format(localDt);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.replayPlanner_snackbar_saved(formatted))),
    );
  }

  Future<void> _cancelPlan(AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.replayPlanner_dialog_confirmCancel_title),
        content: Text(l10n.replayPlanner_dialog_confirmCancel_body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.replayPlanner_btn_no),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.replayPlanner_btn_cancelPlan),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final controller = ref.read(
      replayPlannerControllerProvider(match.matchId).notifier,
    );
    await controller.cancelPlan(match);

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.replayPlanner_snackbar_cancelled)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateStr = _pickedDate != null
        ? DateFormat('dd/MM/yyyy').format(_pickedDate!)
        : l10n.replayPlanner_placeholder_date;
    final timeStr =
        _pickedTime != null ? _pickedTime!.format(context) : l10n.replayPlanner_placeholder_time;

    final planState =
        ref.watch(replayPlannerControllerProvider(match.matchId));

    return AlertDialog(
      title: Text(l10n.replayPlanner_dialog_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Date picker button
          OutlinedButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: Text(dateStr),
            onPressed: () => _pickDate(l10n),
          ),
          const SizedBox(height: 8),
          // Time picker button
          OutlinedButton.icon(
            icon: const Icon(Icons.schedule),
            label: Text(timeStr),
            onPressed: () => _pickTime(l10n),
          ),
          if (_validationError != null) ...[
            const SizedBox(height: 8),
            Text(
              _validationError!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
      actions: [
        // Cancel existing plan button (only if plan exists)
        if (planState.enabled)
          TextButton(
            onPressed: () => _cancelPlan(l10n),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.replayPlanner_btn_cancelPlan),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.replayPlanner_btn_close),
        ),
        FilledButton(
          onPressed: _canSave ? () => _save(l10n) : null,
          child: Text(l10n.replayPlanner_btn_save),
        ),
      ],
    );
  }
}
