import 'package:sqflite/sqflite.dart';

import '../../core/storage/local_database.dart';
import '../../domain/models/announcement.dart';
import '../../domain/models/event_item.dart';
import '../../domain/models/timetable_item.dart';

/// Handles all local SQLite read/write operations for offline-first behavior.
class CampusLocalDataSource {
  Future<Database> get _db async => LocalDatabase.open();

  Future<void> cacheAnnouncements(List<Announcement> announcements) async {
    final db = await _db;
    final batch = db.batch();

    // We replace table content so cache always reflects latest successful sync.
    batch.delete('announcements');
    for (final item in announcements) {
      batch.insert('announcements', item.toMap());
    }

    await batch.commit(noResult: true);
  }

  Future<void> cacheEvents(List<EventItem> events) async {
    final db = await _db;
    final batch = db.batch();

    batch.delete('events');
    for (final item in events) {
      batch.insert('events', item.toMap());
    }

    await batch.commit(noResult: true);
  }

  Future<void> cacheTimetable(List<TimetableItem> timetable) async {
    final db = await _db;
    final batch = db.batch();

    batch.delete('timetable');
    for (final item in timetable) {
      batch.insert('timetable', item.toMap());
    }

    await batch.commit(noResult: true);
  }

  Future<List<Announcement>> getAnnouncements() async {
    final db = await _db;
    final rows = await db.query('announcements', orderBy: 'id DESC');
    return rows.map(Announcement.fromJson).toList();
  }

  Future<List<EventItem>> getEvents() async {
    final db = await _db;
    final rows = await db.query('events', orderBy: 'id DESC');
    return rows.map(EventItem.fromJson).toList();
  }

  Future<List<TimetableItem>> getTimetable() async {
    final db = await _db;
    final rows = await db.query('timetable', orderBy: 'id ASC');
    return rows.map((row) {
      return TimetableItem.fromJson({
        'id': row['id'],
        'title': row['title'],
        'completed': (row['completed'] as int) == 1,
      });
    }).toList();
  }
}
