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
/// Loaded once from the bundled [team_names_vi.json] asset.
class TeamLookupService {
  TeamLookupService._();

  static TeamLookupService? _instance;
  static TeamLookupService get instance {
    _instance ??= TeamLookupService._();
    return _instance!;
  }

  final Map<String, TeamInfo> _byNameEn = {};
  bool _loaded = false;

  /// Loads the team data from the bundled asset. Call once at app start.
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

/// Riverpod provider for [TeamLookupService].
/// The service is loaded lazily — call [TeamLookupService.instance.load()] at boot.
final teamLookupProvider = Provider<TeamLookupService>(
  (_) => TeamLookupService.instance,
);
