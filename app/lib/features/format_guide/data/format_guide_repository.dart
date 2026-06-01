import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'format_guide_section.dart';

/// Repository for format guide sections loaded from the bundled JSON asset.
///
/// Design decisions:
/// - No Isar — content is read-only and small (6 sections).
/// - Lazy load on first [getAll] call; subsequent calls use in-memory cache.
class FormatGuideRepository {
  List<FormatGuideSection>? _cache;

  /// Load all format guide sections from the bundled JSON asset.
  ///
  /// First call reads `assets/data/format_guide.json` via [rootBundle].
  /// Subsequent calls return the cached list.
  Future<List<FormatGuideSection>> getAll() async {
    if (_cache != null) return _cache!;

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/format_guide.json');
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final sectionsJson = jsonMap['sections'] as List<dynamic>;
      _cache = sectionsJson
          .map((e) => FormatGuideSection.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cache!;
    } catch (e) {
      // Surface error to caller — AsyncValue.error will handle UI state.
      rethrow;
    }
  }

  /// Returns the section with the given [id], or null if not found.
  Future<FormatGuideSection?> getById(String id) async {
    final sections = await getAll();
    try {
      return sections.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Provider for [FormatGuideRepository].
///
/// Uses a simple [Provider] since the repository itself is synchronous to
/// construct — the async work happens inside [getAll].
final formatGuideRepositoryProvider = Provider<FormatGuideRepository>(
  (_) => FormatGuideRepository(),
);

/// Provider that loads all format guide sections.
final formatGuideSectionsProvider =
    FutureProvider<List<FormatGuideSection>>((ref) async {
  final repo = ref.watch(formatGuideRepositoryProvider);
  return repo.getAll();
});
