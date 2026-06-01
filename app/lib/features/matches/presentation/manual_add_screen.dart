import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

import '../../../core/routing/routes.dart';
import '../../../core/time/timezone_service.dart';
import '../../../l10n/app_localizations.dart';
import '../data/match.dart';
import '../data/match_repository.dart';
import '../../reminders/application/reminder_scheduler.dart';

/// Form screen for manually adding or editing a custom match.
///
/// Fields: home team, away team, kickoff date, kickoff time, venue, notes.
/// Supports pre-filling from query parameters (used by Magic Add fallthrough).
/// When [editMatchId] is non-null, loads the existing match and updates on save.
class ManualAddScreen extends ConsumerStatefulWidget {
  const ManualAddScreen({
    super.key,
    this.prefillHome,
    this.prefillAway,
    this.prefillSourceText,
    this.editMatchId,
  });

  /// Pre-filled home team name (from Magic Add fallthrough).
  final String? prefillHome;

  /// Pre-filled away team name (from Magic Add fallthrough).
  final String? prefillAway;

  /// Original source text from Magic Add (preserved on save).
  final String? prefillSourceText;

  /// When non-null, the screen is in edit mode and loads this match.
  final String? editMatchId;

  @override
  ConsumerState<ManualAddScreen> createState() => _ManualAddScreenState();
}

class _ManualAddScreenState extends ConsumerState<ManualAddScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _homeCtrl;
  late final TextEditingController _awayCtrl;
  late final TextEditingController _venueCtrl;
  late final TextEditingController _notesCtrl;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _saving = false;
  String? _saveError;

  // Edit mode: the original match being edited (loaded in initState).
  Match? _editingMatch;

  bool get _isEditMode => widget.editMatchId != null;

  @override
  void initState() {
    super.initState();
    _homeCtrl = TextEditingController(text: widget.prefillHome ?? '');
    _awayCtrl = TextEditingController(text: widget.prefillAway ?? '');
    _venueCtrl = TextEditingController();
    _notesCtrl = TextEditingController();

    if (_isEditMode) {
      _loadMatchForEdit();
    }
  }

  Future<void> _loadMatchForEdit() async {
    final repo = await ref.read(matchRepositoryProvider.future);
    final match = await repo.getById(widget.editMatchId!);
    if (match == null || !mounted) return;

    // Convert UTC kickoff to local date/time for the form fields.
    final localKickoff = tz.TZDateTime.from(match.kickoffAtUtc.toUtc(), tz.local);

    setState(() {
      _editingMatch = match;
      _homeCtrl.text = match.teamA;
      _awayCtrl.text = match.teamB;
      _venueCtrl.text = match.venueCity ?? '';
      _notesCtrl.text = match.notes;
      _selectedDate = DateTime(localKickoff.year, localKickoff.month, localKickoff.day);
      _selectedTime = TimeOfDay(hour: localKickoff.hour, minute: localKickoff.minute);
    });
  }

  @override
  void dispose() {
    _homeCtrl.dispose();
    _awayCtrl.dispose();
    _venueCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  bool get _canSave {
    final home = _homeCtrl.text.trim();
    final away = _awayCtrl.text.trim();
    return home.isNotEmpty &&
        away.isNotEmpty &&
        home.toLowerCase() != away.toLowerCase() &&
        _selectedDate != null &&
        _selectedTime != null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    // In edit mode, allow selecting past dates (the match may have already happened).
    final firstDate = _isEditMode ? DateTime(2020) : now;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() {
      _saving = true;
      _saveError = null;
    });

    try {
      final tzService = ref.read(timezoneServiceProvider);
      final localTzName = tzService.localTimezoneName;
      final location = tz.getLocation(localTzName);

      // Build local TZDateTime from selected date + time
      final localDt = tz.TZDateTime(
        location,
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Convert to UTC
      final utcDt = localDt.toUtc();

      final existing = _editingMatch;
      final match = Match()
        ..matchId = existing?.matchId ?? const Uuid().v4()
        ..title = '${_homeCtrl.text.trim()} vs ${_awayCtrl.text.trim()}'
        ..teamA = _homeCtrl.text.trim()
        ..teamB = _awayCtrl.text.trim()
        ..kickoffAtUtc = utcDt
        ..sourceTimezone = existing?.sourceTimezone ?? localTzName
        ..userTimezone = localTzName
        ..reminders = existing?.reminders ?? kReminderOffsets
        ..replayPlannerEnabled = existing?.replayPlannerEnabled ?? false
        ..replayPlannedAt = existing?.replayPlannedAt
        ..sourceText = existing?.sourceText ?? widget.prefillSourceText
        ..notes = _notesCtrl.text.trim()
        ..createdAt = existing?.createdAt ?? DateTime.now().toUtc()
        ..isSeeded = existing?.isSeeded ?? false
        ..tournamentId = existing?.tournamentId
        ..worldCupGroup = existing?.worldCupGroup
        ..worldCupRound = existing?.worldCupRound
        ..matchday = existing?.matchday
        ..venueCity = _venueCtrl.text.trim().isEmpty
            ? null
            : _venueCtrl.text.trim()
        ..venueIanaTimezone = existing?.venueIanaTimezone;

      final repo = await ref.read(matchRepositoryProvider.future);
      await repo.upsert(match);

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.manualAdd_snackbar_saved)),
        );
        context.go(Routes.matches);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        setState(() {
          _saving = false;
          _saveError = '${l10n.manualAdd_error_prefix}$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateStr = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : l10n.manualAdd_placeholder_date;
    final timeStr = _selectedTime != null
        ? _selectedTime!.format(context)
        : l10n.manualAdd_placeholder_time;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? l10n.manualAdd_appBar_title_edit : l10n.manualAdd_appBar_title,
        ),
      ),
      body: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _homeCtrl,
              decoration: InputDecoration(
                labelText: l10n.manualAdd_field_homeTeam,
                hintText: l10n.manualAdd_field_homeTeam_hint,
              ),
              maxLength: 50,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l10n.manualAdd_validation_required;
                if (v.trim().toLowerCase() ==
                    _awayCtrl.text.trim().toLowerCase()) {
                  return l10n.manualAdd_validation_sameTeam;
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _awayCtrl,
              decoration: InputDecoration(
                labelText: l10n.manualAdd_field_awayTeam,
                hintText: l10n.manualAdd_field_awayTeam_hint,
              ),
              maxLength: 50,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l10n.manualAdd_validation_required;
                if (v.trim().toLowerCase() ==
                    _homeCtrl.text.trim().toLowerCase()) {
                  return l10n.manualAdd_validation_sameTeam;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Date picker
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(dateStr),
              subtitle: Text(l10n.manualAdd_field_date),
              onTap: _pickDate,
              trailing: const Icon(Icons.chevron_right),
            ),
            const Divider(),
            // Time picker
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: Text(timeStr),
              subtitle: Text(l10n.manualAdd_field_time),
              onTap: _pickTime,
              trailing: const Icon(Icons.chevron_right),
            ),
            const Divider(),
            const SizedBox(height: 8),
            TextFormField(
              controller: _venueCtrl,
              decoration: InputDecoration(
                labelText: l10n.manualAdd_field_venue,
                hintText: l10n.manualAdd_field_venue_hint,
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesCtrl,
              decoration: InputDecoration(
                labelText: l10n.manualAdd_field_notes,
              ),
              maxLines: 3,
              maxLength: 500,
            ),
            if (_saveError != null) ...[
              const SizedBox(height: 8),
              Text(
                _saveError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _save,
                child: Text(l10n.manualAdd_btn_retry),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _canSave && !_saving ? _save : null,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.manualAdd_btn_save),
            ),
          ],
        ),
      ),
    );
  }
}
