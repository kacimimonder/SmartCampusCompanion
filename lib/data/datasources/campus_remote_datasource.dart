import '../../core/network/api_client.dart';
import '../../domain/models/announcement.dart';
import '../../domain/models/event_item.dart';
import '../../domain/models/timetable_item.dart';

/// Handles raw REST interactions and converts JSON to domain models.
class CampusRemoteDataSource {
  const CampusRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Announcement>> fetchAnnouncements() async {
    final data = await _apiClient.getList('/posts?_limit=12');
    return data
        .map((item) => Announcement.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<EventItem>> fetchEvents() async {
    final data = await _apiClient.getList('/albums?_limit=12');
    return data
        .map((item) => EventItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<TimetableItem>> fetchTimetable() async {
    final data = await _apiClient.getList('/todos?_limit=12');
    return data
        .map((item) => TimetableItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
