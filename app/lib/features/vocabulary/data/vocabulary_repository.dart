import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/bundled_json_repository.dart';
import 'vocabulary_item.dart';

/// Repository for vocabulary terms loaded from the bundled JSON asset.
///
/// Design decisions:
/// - D1: No Isar — content is read-only and small (17 terms).
/// - D3: Diacritic-insensitive search via [_stripVietnameseDiacritics].
/// - Lazy load on first [getAll] call; subsequent calls use in-memory cache.
class VocabularyRepository extends BundledJsonRepository<VocabularyItem> {
  VocabularyRepository()
      : super(
          assetPath: 'assets/data/vocabulary.json',
          rootKey: 'terms',
          fromJson: VocabularyItem.fromJson,
          idOf: (item) => item.id,
        );

  /// Sort alphabetically by Vietnamese term before caching.
  @override
  List<VocabularyItem> postProcess(List<VocabularyItem> items) {
    items.sort((a, b) => a.termVi.compareTo(b.termVi));
    return items;
  }

  /// Search vocabulary terms.
  ///
  /// Matches against [termVi], [termViNoDiacritics], and [termEn],
  /// all case-insensitive. Empty or null query returns all items.
  ///
  /// Per D3: the query is also diacritic-stripped before matching against
  /// [termViNoDiacritics], so "viet vi" matches "Việt vị".
  Future<List<VocabularyItem>> search(String? query) async {
    final items = await getAll();

    if (query == null || query.isEmpty) return items;

    final q = query.toLowerCase();
    final qNoDiacritics = _stripVietnameseDiacritics(q);

    return items.where((item) {
      return item.termVi.toLowerCase().contains(q) ||
          item.termViNoDiacritics.toLowerCase().contains(qNoDiacritics) ||
          item.termEn.toLowerCase().contains(q);
    }).toList();
  }

  /// Strip Vietnamese diacritics from [input] to produce an ASCII-comparable string.
  ///
  /// Covers all Vietnamese tone marks and vowel modifications.
  /// This mirrors the logic used to generate [VocabularyItem.termViNoDiacritics]
  /// in the content authoring pipeline.
  static String _stripVietnameseDiacritics(String input) {
    const replacements = <String, String>{
      // a variants
      'à': 'a', 'á': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
      'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a',
      'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
      // e variants
      'è': 'e', 'é': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
      'ê': 'e', 'ề': 'e', 'ế': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
      // i variants
      'ì': 'i', 'í': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
      // o variants
      'ò': 'o', 'ó': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
      'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
      'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
      // u variants
      'ù': 'u', 'ú': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
      'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
      // y variants
      'ỳ': 'y', 'ý': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y',
      // d variant
      'đ': 'd',
    };

    // Use replaceAllMapped to handle multi-byte Unicode characters correctly.
    // The regex matches any single character; we replace known diacritics.
    return input.splitMapJoin(
      RegExp(r'.', dotAll: true),
      onMatch: (m) => replacements[m.group(0)!] ?? m.group(0)!,
      onNonMatch: (s) => s,
    );
  }
}

/// Provider for [VocabularyRepository].
final vocabularyRepositoryProvider = Provider<VocabularyRepository>(
  (_) => VocabularyRepository(),
);
