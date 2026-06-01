import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'etiquette_tip.dart';

/// Repository for etiquette tips loaded from the bundled JSON asset.
///
/// Design decisions:
/// - No Isar — content is read-only and small (7 tips).
/// - Lazy load on first [getAll] call; subsequent calls use in-memory cache.
class EtiquetteRepository {
  List<EtiquetteTip>? _cache;

  /// Load all 7 etiquette tips from the bundled JSON asset.
  ///
  /// First call reads `assets/data/etiquette_tips.json` via [rootBundle].
  /// Subsequent calls return the cached list.
  Future<List<EtiquetteTip>> getAll() async {
    if (_cache != null) return _cache!;

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/etiquette_tips.json');
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final tipsJson = jsonMap['tips'] as List<dynamic>;
      _cache = tipsJson
          .map((e) => EtiquetteTip.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cache!;
    } catch (e) {
      // Surface error to caller — AsyncValue.error will handle UI state.
      rethrow;
    }
  }

  /// Returns the tip with the given [id], or null if not found.
  Future<EtiquetteTip?> getById(String id) async {
    final tips = await getAll();
    try {
      return tips.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Provider for [EtiquetteRepository].
///
/// Uses a simple [Provider] since the repository itself is synchronous to
/// construct — the async work happens inside [getAll].
final etiquetteRepositoryProvider = Provider<EtiquetteRepository>(
  (_) => EtiquetteRepository(),
);

/// Provider that loads all etiquette tips.
final etiquetteTipsProvider = FutureProvider<List<EtiquetteTip>>((ref) async {
  final repo = ref.watch(etiquetteRepositoryProvider);
  return repo.getAll();
});
