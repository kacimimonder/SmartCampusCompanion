import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/models/campus_data_bundle.dart';
import '../../domain/models/announcement.dart';
import '../../domain/models/event_item.dart';
import '../../domain/models/timetable_item.dart';
import '../datasources/campus_local_datasource.dart';
import '../datasources/campus_remote_datasource.dart';

/// Repository abstracts data origin and implements offline-first fetch strategy.
class CampusRepository {
  const CampusRepository(
    this._remoteDataSource,
    this._localDataSource,
    this._connectivity,
  );

  final CampusRemoteDataSource _remoteDataSource;
  final CampusLocalDataSource _localDataSource;
  final Connectivity _connectivity;

  /// Loads all core datasets using remote data when online and cache when offline.
  Future<CampusDataBundle> getDashboardData() async {
    final connectionResults = await _connectivity.checkConnectivity();
    final hasNetwork = !connectionResults.contains(ConnectivityResult.none);

    if (hasNetwork) {
      try {
        final fetchedData = await Future.wait([
          _remoteDataSource.fetchAnnouncements(),
          _remoteDataSource.fetchEvents(),
          _remoteDataSource.fetchTimetable(),
        ]);

        final announcements = fetchedData[0] as List<Announcement>;
        final events = fetchedData[1] as List<EventItem>;
        final timetable = fetchedData[2] as List<TimetableItem>;

        // Cache successful network responses for offline browsing.
        await Future.wait([
          _localDataSource.cacheAnnouncements(announcements),
          _localDataSource.cacheEvents(events),
          _localDataSource.cacheTimetable(timetable),
        ]);

        return CampusDataBundle(
          announcements: announcements,
          events: events,
          timetable: timetable,
          isOffline: false,
          loadedFromCache: false,
        );
      } catch (_) {
        // If online fetch fails, fallback to cache before surfacing an error.
        return _loadFromCacheOrThrow();
      }
    }

    return _loadFromCacheOrThrow();
  }

  Future<CampusDataBundle> _loadFromCacheOrThrow() async {
    final cachedData = await Future.wait([
      _localDataSource.getAnnouncements(),
      _localDataSource.getEvents(),
      _localDataSource.getTimetable(),
    ]);

    final announcements = cachedData[0] as List<Announcement>;
    final events = cachedData[1] as List<EventItem>;
    final timetable = cachedData[2] as List<TimetableItem>;

    final hasAnyCachedContent =
        announcements.isNotEmpty || events.isNotEmpty || timetable.isNotEmpty;

    if (!hasAnyCachedContent) {
      throw Exception(
        'No internet connection and no cached content is available yet.',
      );
    }

    return CampusDataBundle(
      announcements: announcements,
      events: events,
      timetable: timetable,
      isOffline: true,
      loadedFromCache: true,
    );
  }

  Future<List<Announcement>> getAnnouncements() {
    return getDashboardData().then((data) => data.announcements);
  }

  Future<List<EventItem>> getEvents() {
    return getDashboardData().then((data) => data.events);
  }

  Future<List<TimetableItem>> getTimetable() {
    return getDashboardData().then((data) => data.timetable);
  }
}
