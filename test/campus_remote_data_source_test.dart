import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:smart_campus_companion/core/network/api_client.dart';
import 'package:smart_campus_companion/data/datasources/campus_remote_datasource.dart';

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
  test('fetchAnnouncements maps JSON records into domain models', () async {
    final apiClient = ApiClient(
      client: _FakeClient((request) async {
        expect(request.url.path, '/posts');
        return http.Response(
          jsonEncode([
            {'id': 1, 'title': 'Campus opening', 'body': 'Welcome back'},
          ]),
          200,
        );
      }),
    );

    final dataSource = CampusRemoteDataSource(apiClient);
    final announcements = await dataSource.fetchAnnouncements();

    expect(announcements, hasLength(1));
    expect(announcements.first.id, 1);
    expect(announcements.first.title, 'Campus opening');
    expect(announcements.first.body, 'Welcome back');
  });
}
