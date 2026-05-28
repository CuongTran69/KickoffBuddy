import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// Riverpod async provider that opens and returns the Isar database instance.
///
/// Schema list is empty for Sprint 1 — actual Match and other schemas land in Sprint 2.
/// Note: Isar 3.x allows opening with an empty schema list for initialization purposes.
final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [], // Sprint 2: add Match schema, etc.
    directory: dir.path,
  );
  return isar;
});
