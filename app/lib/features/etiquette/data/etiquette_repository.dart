import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/bundled_json_repository.dart';
import 'etiquette_tip.dart';

/// Repository for etiquette tips loaded from the bundled JSON asset.
///
/// Design decisions:
/// - No Isar — content is read-only and small (7 tips).
/// - Lazy load on first [getAll] call; subsequent calls use in-memory cache.
class EtiquetteRepository extends BundledJsonRepository<EtiquetteTip> {
  EtiquetteRepository()
      : super(
          assetPath: 'assets/data/etiquette_tips.json',
          rootKey: 'tips',
          fromJson: EtiquetteTip.fromJson,
          idOf: (tip) => tip.id,
        );
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
