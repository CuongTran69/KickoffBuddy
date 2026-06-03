import 'dart:convert';

import 'package:flutter/services.dart';

/// Generic base for read-only repositories backed by a bundled JSON asset.
///
/// Captures the shared pattern across the content repositories (etiquette,
/// format guide, rule cards, vocabulary): a lazily-loaded in-memory cache, a
/// `getAll()` that reads `assetPath`, decodes the `rootKey` array and maps each
/// element via `fromJson`, and a `getById()` that returns the first element
/// whose [idOf] matches (or null). Subclasses add any specialized queries.
///
/// Design D10 — behavior is identical to the previous hand-rolled repos; the
/// cache guard and error propagation (rethrow) are preserved.
abstract class BundledJsonRepository<T> {
  BundledJsonRepository({
    required this.assetPath,
    required this.rootKey,
    required this.fromJson,
    required this.idOf,
  });

  /// Path to the bundled JSON asset (e.g. `assets/data/rule_cards.json`).
  final String assetPath;

  /// Top-level JSON key holding the array of items (e.g. `cards`).
  final String rootKey;

  /// Deserializes a single item from its JSON map.
  final T Function(Map<String, dynamic> json) fromJson;

  /// Extracts the stable string ID from an item, used by [getById].
  final String Function(T item) idOf;

  List<T>? _cache;

  /// Loads and caches all items from the bundled asset.
  ///
  /// First call reads [assetPath] via [rootBundle]; subsequent calls return the
  /// cached list. Errors propagate to the caller (AsyncValue.error handles UI).
  Future<List<T>> getAll() async {
    if (_cache != null) return _cache!;

    final jsonString = await rootBundle.loadString(assetPath);
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    final itemsJson = jsonMap[rootKey] as List<dynamic>;
    final items = itemsJson
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
    _cache = postProcess(items);
    return _cache!;
  }

  /// Hook for subclasses to transform the freshly-loaded list (e.g. sort)
  /// before it is cached. Default is identity.
  List<T> postProcess(List<T> items) => items;

  /// Returns the item with the given [id], or null if not found.
  Future<T?> getById(String id) async {
    final items = await getAll();
    for (final item in items) {
      if (idOf(item) == id) return item;
    }
    return null;
  }
}
