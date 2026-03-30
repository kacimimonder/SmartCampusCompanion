import '../datasources/campus_remote_datasource.dart';
import '../../domain/models/announcement.dart';
import '../../domain/models/event_item.dart';
import '../../domain/models/timetable_item.dart';

/// Repository abstracts data origin (API now, local cache in future weeks).
class CampusRepository {
  const CampusRepository(this._remoteDataSource);

  final CampusRemoteDataSource _remoteDataSource;

  Future<List<Announcement>> getAnnouncements() {
    return _remoteDataSource.fetchAnnouncements();
  }

  Future<List<EventItem>> getEvents() {
    return _remoteDataSource.fetchEvents();
  }

  Future<List<TimetableItem>> getTimetable() {
    return _remoteDataSource.fetchTimetable();
  }
}
