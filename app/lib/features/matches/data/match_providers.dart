import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/storage/isar_provider.dart';
import '../../../core/storage/prefs_provider.dart';
import 'seed_loader.dart';

/// Provider that triggers the first-run seed load.
///
/// Watches [isarProvider] and [sharedPreferencesProvider]. When Isar is ready,
/// calls [loadSeedIfEmpty]. Returns [AsyncValue<void>] so callers can react to
/// loading/error states.
///
/// This provider is watched in the app widget to ensure seeding happens before
/// the match list screen reads from Isar.
final seedLoaderProvider = FutureProvider<void>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  final prefs = ref.watch(sharedPreferencesProvider);
  await loadSeedIfEmpty(isar, prefs);
});

/// Convenience provider that exposes the [Isar] instance synchronously
/// once it has been opened. Throws if Isar is not yet ready.
final isarInstanceProvider = Provider<Isar>((ref) {
  return ref.watch(isarProvider).requireValue;
});
