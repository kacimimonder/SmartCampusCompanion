import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:smart_campus_companion/core/network/api_client.dart';

class _FakeClient extends http.BaseClient {
  _FakeClient(this._handler);

  final Future<http.Response> Function(http.BaseRequest request) _handler;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _handler(request);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      request: request,
      headers: response.headers,
      reasonPhrase: response.reasonPhrase,
    );
  }
}

void main() {
  group('ApiClient.getList', () {
    test('returns decoded list for a successful response', () async {
      final client = ApiClient(
        client: _FakeClient((request) async {
          expect(request.url.toString(), 'https://jsonplaceholder.typicode.com/posts');
          return http.Response(jsonEncode([{'id': 1, 'title': 'Alpha'}]), 200);
        }),
      );

      final result = await client.getList('/posts');

      expect(result, hasLength(1));
      expect(result.first, isA<Map<String, dynamic>>());
      expect(result.first['title'], 'Alpha');
    });

    test('throws ApiException for non-2xx status', () async {
      final client = ApiClient(
        client: _FakeClient((request) async {
          return http.Response('server error', 500);
        }),
      );

      expect(
        () => client.getList('/posts'),
        throwsA(
          predicate((error) => error is ApiException && error.message.contains('500')),
        ),
      );
    });

    test('throws ApiException when response body is not a list', () async {
      final client = ApiClient(
        client: _FakeClient((request) async {
          return http.Response(jsonEncode({'message': 'not a list'}), 200);
        }),
      );

      expect(
        () => client.getList('/posts'),
        throwsA(
          predicate((error) => error is ApiException && error.message.contains('JSON list')),
        ),
      );
    });
  });
}
