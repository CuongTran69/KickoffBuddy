import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/bundled_json_repository.dart';
import 'format_guide_section.dart';

/// Repository for format guide sections loaded from the bundled JSON asset.
///
/// Design decisions:
/// - No Isar — content is read-only and small (6 sections).
/// - Lazy load on first [getAll] call; subsequent calls use in-memory cache.
class FormatGuideRepository extends BundledJsonRepository<FormatGuideSection> {
  FormatGuideRepository()
      : super(
          assetPath: 'assets/data/format_guide.json',
          rootKey: 'sections',
          fromJson: FormatGuideSection.fromJson,
          idOf: (section) => section.id,
        );
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
