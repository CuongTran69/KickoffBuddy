import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lookup entry for a WC 2026 team.
class TeamInfo {
  const TeamInfo({
    required this.fifaCode,
    required this.nameEn,
    required this.nameVi,
    required this.isoAlpha2,
    required this.group,
  });

  final String fifaCode;
  final String nameEn;
  final String nameVi;

  /// ISO alpha-2 code for flag rendering.
  /// Note: Scotland = "GB-SCT", England = "GB-ENG" (subdivision codes).
  final String isoAlpha2;
  final String group;
}

/// Service for looking up team info by English name or FIFA code.
///
/// Loaded once from the bundled [team_names_vi.json] asset. Managed by Riverpod
/// (design D6) — no static singleton, so it is testable/overridable and never
/// stale across hot-restart.
class TeamLookupService {
  TeamLookupService();

  final Map<String, TeamInfo> _byNameEn = {};
  bool _loaded = false;

  /// Loads the team data from the bundled asset. Idempotent.
  Future<void> load() async {
    if (_loaded) return;
    final jsonString =
        await rootBundle.loadString('assets/data/team_names_vi.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final teams = data['teams'] as List<dynamic>;
    for (final t in teams) {
      final map = t as Map<String, dynamic>;
      final info = TeamInfo(
        fifaCode: map['fifa_code'] as String,
        nameEn: map['name_en'] as String,
        nameVi: map['name_vi'] as String,
        isoAlpha2: map['iso_alpha2'] as String,
        group: map['group'] as String,
      );
      _byNameEn[info.nameEn.toLowerCase()] = info;
    }
    _loaded = true;
  }

  /// Returns [TeamInfo] for the given English team name, or null if not found.
  TeamInfo? byName(String nameEn) => _byNameEn[nameEn.toLowerCase()];

  /// Returns the Vietnamese name for [nameEn], or [nameEn] if not found.
  String viName(String nameEn) => byName(nameEn)?.nameVi ?? nameEn;

  /// Returns the ISO alpha-2 code for [nameEn], or null if not found.
  String? isoAlpha2(String nameEn) => byName(nameEn)?.isoAlpha2;
}

/// Loads the [TeamLookupService] asset once for the app lifetime (design D6).
///
/// Kept alive (not autoDispose) since the data is app-lifetime constant.
final teamLookupServiceProvider =
    FutureProvider<TeamLookupService>((ref) async {
  final service = TeamLookupService();
  await service.load();
  return service;
});

/// Synchronous accessor for the team lookup service.
///
/// Returns the loaded service once [teamLookupServiceProvider] resolves; while
/// the load is in flight it returns an empty (unloaded) instance so consumers
/// degrade gracefully to English names, then rebuild when the data arrives.
final teamLookupProvider = Provider<TeamLookupService>((ref) {
  return ref.watch(teamLookupServiceProvider).valueOrNull ??
      TeamLookupService();
});
