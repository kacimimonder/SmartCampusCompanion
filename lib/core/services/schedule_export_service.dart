import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../domain/models/timetable_item.dart';

/// Service for exporting timetable schedules to JSON files.
class ScheduleExportService {
  /// Exports a list of timetable items to a JSON file.
  /// Returns the file path on success, or throws an exception on failure.
  Future<String> exportTimetableAsJson(List<TimetableItem> items) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'campus_schedule_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');

      // Convert timetable items to JSON
      final jsonData = {
        'exportedAt': DateTime.now().toIso8601String(),
        'itemCount': items.length,
        'items': items.map((item) {
          return {
            'id': item.id,
            'title': item.title,
            'completed': item.completed,
          };
        }).toList(),
      };

      // Write JSON to file
      await file.writeAsString(
        JsonEncoder.withIndent('  ').convert(jsonData),
      );

      return file.path;
    } catch (e) {
      throw Exception('Failed to export schedule: $e');
    }
  }

  /// Exports schedule as JSON and returns the raw JSON string.
  String exportTimetableAsJsonString(List<TimetableItem> items) {
    final jsonData = {
      'exportedAt': DateTime.now().toIso8601String(),
      'itemCount': items.length,
      'items': items.map((item) {
        return {
          'id': item.id,
          'title': item.title,
          'completed': item.completed,
        };
      }).toList(),
    };

    return JsonEncoder.withIndent('  ').convert(jsonData);
  }
}
