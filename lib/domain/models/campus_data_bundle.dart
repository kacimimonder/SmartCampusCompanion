import 'announcement.dart';
import 'event_item.dart';
import 'timetable_item.dart';

/// Aggregates data needed by the dashboard and content screens in one payload.
class CampusDataBundle {
  const CampusDataBundle({
    required this.announcements,
    required this.events,
    required this.timetable,
    required this.isOffline,
    required this.loadedFromCache,
  });

  final List<Announcement> announcements;
  final List<EventItem> events;
  final List<TimetableItem> timetable;
  final bool isOffline;
  final bool loadedFromCache;
}
