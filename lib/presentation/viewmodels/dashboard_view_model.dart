import 'package:flutter/foundation.dart';

import '../../data/repositories/campus_repository.dart';
import '../../domain/models/announcement.dart';
import '../../domain/models/event_item.dart';
import '../../domain/models/timetable_item.dart';

/// ViewModel manages screen data/state and isolates UI from data-layer details.
class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel(this._repository);

  final CampusRepository _repository;

  List<Announcement> _announcements = const [];
  List<EventItem> _events = const [];
  List<TimetableItem> _timetable = const [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Announcement> get announcements => _announcements;
  List<EventItem> get events => _events;
  List<TimetableItem> get timetable => _timetable;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get pendingClassesCount => _timetable.where((item) => !item.completed).length;

  TimetableItem? get nextClass {
    for (final item in _timetable) {
      if (!item.completed) {
        return item;
      }
    }
    return null;
  }

  /// Loads all dashboard data in parallel for better perceived performance.
  Future<void> loadAllData() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getAnnouncements(),
        _repository.getEvents(),
        _repository.getTimetable(),
      ]);

      _announcements = results[0] as List<Announcement>;
      _events = results[1] as List<EventItem>;
      _timetable = results[2] as List<TimetableItem>;
    } catch (error) {
      _errorMessage = 'Could not load campus data. Check internet and try again.';
      if (kDebugMode) {
        print('DashboardViewModel.loadAllData error: $error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
