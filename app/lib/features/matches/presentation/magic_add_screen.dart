import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

import '../../../core/routing/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../application/magic_add_parser.dart';
import '../data/match.dart';
import '../data/match_repository.dart';
import '../../../features/reminders/application/reminder_scheduler.dart';

/// Magic Add screen — paste a match snippet and let the regex parser extract it.
///
/// Flow:
/// - Full parse → confirmation screen → save
/// - Partial parse → navigate to ManualAddScreen with prefilled fields
/// - Failed parse → inline feedback + "Add manually" button
class MagicAddScreen extends ConsumerStatefulWidget {
  const MagicAddScreen({super.key});

  @override
  ConsumerState<MagicAddScreen> createState() => _MagicAddScreenState();
}

class _MagicAddScreenState extends ConsumerState<MagicAddScreen> {
  final _textCtrl = TextEditingController();
  MagicAddResult? _result;
  bool _parsed = false;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    try {
      final data = await Clipboard.getData('text/plain');
      if (data?.text != null && data!.text!.isNotEmpty) {
        setState(() => _textCtrl.text = data.text!);
      }
      // If denied or null → no-op, no error popup (per compliance/02-store-review.md)
    } catch (_) {
      // Clipboard access denied — silently ignore
    }
  }

  void _parse() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    final parser = ref.read(magicAddParserProvider);
    final result = parser.parse(text);
    setState(() {
      _result = result;
      _parsed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).magicAdd_appBar_title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context).magicAdd_instruction,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText:
                    'e.g. USA vs Mexico, June 11, 8 PM ET',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                if (_parsed) setState(() => _parsed = false);
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.paste),
                  label: Text(AppLocalizations.of(context).magicAdd_btn_paste),
                  onPressed: _pasteFromClipboard,
                ),
                const Spacer(),
                FilledButton.icon(
                  icon: const Icon(Icons.auto_fix_high),
                  label: Text(AppLocalizations.of(context).magicAdd_btn_analyze),
                  onPressed: _textCtrl.text.trim().isNotEmpty ? _parse : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_parsed && _result != null) _buildResult(context, _result!),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context, MagicAddResult result) {
    if (result.isComplete) {
      return _ConfirmationCard(result: result);
    }

    if (result.hasTeams) {
      // Partial parse — navigate to manual add with prefilled fields
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).magicAdd_result_teamsFound,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text('${result.teamA} vs ${result.teamB}'),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).magicAdd_result_missingDateTime,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => _goToManualAdd(context, result),
            child: Text(AppLocalizations.of(context).magicAdd_btn_fillMore),
          ),
        ],
      );
    }

    // Complete failure
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: Theme.of(context).colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              AppLocalizations.of(context).magicAdd_result_failed,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => context.push(Routes.matchesAdd),
          child: Text(AppLocalizations.of(context).magicAdd_btn_addManually),
        ),
      ],
    );
  }

  void _goToManualAdd(BuildContext context, MagicAddResult result) {
    context.push(
      Routes.matchesAddWith(
        home: result.teamA,
        away: result.teamB,
        sourceText: result.originalText,
      ),
    );
  }
}

/// Confirmation card shown after a full successful parse.
class _ConfirmationCard extends ConsumerWidget {
  const _ConfirmationCard({required this.result});

  final MagicAddResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final date = result.date!;
    final time = result.time!;
    final dateStr = DateFormat('dd/MM/yyyy').format(date);
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.magicAdd_confirmation_title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                _Row(label: l10n.magicAdd_field_home, value: result.teamA!),
                _Row(label: l10n.magicAdd_field_away, value: result.teamB!),
                _Row(label: l10n.magicAdd_field_date, value: dateStr),
                _Row(label: l10n.magicAdd_field_time, value: timeStr),
                _Row(
                  label: l10n.magicAdd_field_timezone,
                  value: result.ianaTimezone ?? l10n.magicAdd_field_timezone_local,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () => _save(context, ref),
          child: Text(l10n.magicAdd_btn_save),
        ),
        const SizedBox(height: 4),
        OutlinedButton(
          onPressed: () => _edit(context),
          child: Text(l10n.magicAdd_btn_edit),
        ),
      ],
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    try {
      final date = result.date!;
      final time = result.time!;
      final ianaName = result.ianaTimezone ?? tz.local.name;
      final location = tz.getLocation(ianaName);

      final localDt = tz.TZDateTime(
        location,
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      final utcDt = localDt.toUtc();

      final match = Match()
        ..matchId = const Uuid().v4()
        ..title = '${result.teamA} vs ${result.teamB}'
        ..teamA = result.teamA!
        ..teamB = result.teamB!
        ..kickoffAtUtc = utcDt
        ..sourceTimezone = ianaName
        ..userTimezone = tz.local.name
        ..reminders = kReminderOffsets
        ..replayPlannerEnabled = false
        ..replayPlannedAt = null
        ..sourceText = result.originalText
        ..notes = ''
        ..createdAt = DateTime.now().toUtc()
        ..isSeeded = false
        ..tournamentId = null
        ..worldCupGroup = null
        ..worldCupRound = null
        ..matchday = null
        ..venueCity = null
        ..venueIanaTimezone = null;

      final repo = await ref.read(matchRepositoryProvider.future);
      await repo.upsert(match);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).magicAdd_snackbar_saved)),
        );
        context.go(Routes.matches);
      }
    } catch (e) {
      debugPrint('[MagicAddScreen] save error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).magicAdd_snackbar_error)),
        );
      }
    }
  }

  void _edit(BuildContext context) {
    context.push(
      Routes.matchesAddWith(
        home: result.teamA,
        away: result.teamB,
        sourceText: result.originalText,
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
