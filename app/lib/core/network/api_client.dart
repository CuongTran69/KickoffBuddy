import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'api_models.dart';

/// HTTP client wrapper for the World Cup JSON API.
///
/// Endpoints:
/// - GET /matches           → All matches (scores, venues, attendance)
/// - GET /matches/today     → Today's matches
/// - GET /matches/current   → Currently live matches
/// - GET /teams             → Group standings
///
/// All methods return parsed DTOs. Network errors throw [WorldCupApiException].
class WorldCupApiClient {
  WorldCupApiClient({http.Client? httpClient})
      : _client = httpClient ?? http.Client();

  static const _baseUrl = 'https://worldcupjson.net';
  static const _timeout = Duration(seconds: 10);

  final http.Client _client;

  /// Fetches all matches.
  Future<List<ApiMatch>> getMatches() async {
    final json = await _getList('/matches');
    return json.map((e) => ApiMatch.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Fetches today's matches.
  Future<List<ApiMatch>> getTodayMatches() async {
    final json = await _getList('/matches/today');
    return json.map((e) => ApiMatch.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Fetches currently live matches.
  Future<List<ApiMatch>> getCurrentMatches() async {
    final json = await _getList('/matches/current');
    return json.map((e) => ApiMatch.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Fetches team standings grouped by letter.
  Future<ApiTeamsResponse> getTeams() async {
    final json = await _getMap('/teams');
    return ApiTeamsResponse.fromJson(json);
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> _getList(String path) async {
    final body = await _fetchBody(path);
    final decoded = json.decode(body);
    if (decoded is List) return decoded;
    throw WorldCupApiException('Expected JSON array from $path');
  }

  Future<Map<String, dynamic>> _getMap(String path) async {
    final body = await _fetchBody(path);
    final decoded = json.decode(body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw WorldCupApiException('Expected JSON object from $path');
  }

  Future<String> _fetchBody(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode != 200) {
        throw WorldCupApiException(
          'HTTP ${response.statusCode} from $path',
        );
      }
      return response.body;
    } catch (e) {
      if (e is WorldCupApiException) rethrow;
      debugPrint('[WorldCupApiClient] Error fetching $path: $e');
      throw WorldCupApiException('Network error: $e');
    }
  }

  /// Releases underlying HTTP resources.
  void dispose() => _client.close();
}

/// Exception thrown by [WorldCupApiClient] on network or parse errors.
class WorldCupApiException implements Exception {
  const WorldCupApiException(this.message);
  final String message;

  @override
  String toString() => 'WorldCupApiException: $message';
}

/// Riverpod provider for [WorldCupApiClient].
///
/// The client is kept alive for the app's lifetime so the underlying
/// HTTP connection pool can be reused.
final apiClientProvider = Provider<WorldCupApiClient>((ref) {
  final client = WorldCupApiClient();
  ref.onDispose(client.dispose);
  return client;
});
