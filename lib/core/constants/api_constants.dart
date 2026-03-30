/// Central place for API-related constants so they are easy to change later.
class ApiConstants {
  // JSONPlaceholder is used as a mock backend for Week 2 networking.
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Timeout keeps network calls from hanging forever on poor networks.
  static const Duration requestTimeout = Duration(seconds: 12);
}
