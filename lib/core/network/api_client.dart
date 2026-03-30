import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

/// Thin HTTP client wrapper that handles timeout, status checks, and JSON parsing.
class ApiClient {
  const ApiClient({http.Client? client}) : _client = client;

  final http.Client? _client;

  http.Client get _httpClient => _client ?? http.Client();

  /// Sends GET requests and returns decoded JSON list data.
  Future<List<dynamic>> getList(String endpoint) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    final response = await _httpClient
        .get(uri)
        .timeout(ApiConstants.requestTimeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Request failed (${response.statusCode}) for endpoint $endpoint',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List<dynamic>) {
      throw const ApiException('Expected a JSON list response.');
    }

    return decoded;
  }
}

/// Custom exception makes UI error messages and debugging more explicit.
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
