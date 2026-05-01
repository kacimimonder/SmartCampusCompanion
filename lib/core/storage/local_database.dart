import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Provides a single SQLite database instance for local/offline persistence.
class LocalDatabase {
  static Database? _instance;

  /// Opens (or creates) the local DB used for caching campus content.
  static Future<Database> open() async {
    if (_instance != null) {
      return _instance!;
    }

    final dbPath = await getDatabasesPath();
    final fullPath = p.join(dbPath, 'smart_campus_companion.db');

    final database = kIsWeb ? databaseFactoryFfiWeb : databaseFactory;

    _instance = await database.openDatabase(
      fullPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE announcements (
              id INTEGER PRIMARY KEY,
              title TEXT NOT NULL,
              body TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE events (
              id INTEGER PRIMARY KEY,
              title TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE timetable (
              id INTEGER PRIMARY KEY,
              title TEXT NOT NULL,
              completed INTEGER NOT NULL
            )
          ''');
        },
      ),
    );

    return _instance!;
  }
}
