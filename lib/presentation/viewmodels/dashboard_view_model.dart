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
  bool _isOfflineMode = false;
  bool _loadedFromCache = false;

  List<Announcement> get announcements => _announcements;
  List<EventItem> get events => _events;
  List<TimetableItem> get timetable => _timetable;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOfflineMode => _isOfflineMode;
  bool get loadedFromCache => _loadedFromCache;

  int get pendingClassesCount =>
      _timetable.where((item) => !item.completed).length;

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
      final dataBundle = await _repository.getDashboardData();

      _announcements = dataBundle.announcements;
      _events = dataBundle.events;
      _timetable = dataBundle.timetable;
      _isOfflineMode = dataBundle.isOffline;
      _loadedFromCache = dataBundle.loadedFromCache;
    } catch (error) {
      _errorMessage =
          'Could not load campus data. Check internet and try again.';
      _isOfflineMode = true;
      _loadedFromCache = false;
      if (kDebugMode) {
        print('DashboardViewModel.loadAllData error: $error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
