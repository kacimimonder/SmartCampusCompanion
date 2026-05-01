import 'dart:async';

import '../../presentation/viewmodels/dashboard_view_model.dart';

/// Lightweight periodic refresh helper used to keep campus data warm while
/// the app is open.
class BackgroundRefreshService {
  BackgroundRefreshService(this._viewModel);

  final DashboardViewModel _viewModel;
  Timer? _timer;

  void start({Duration interval = const Duration(minutes: 15)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) {
      _viewModel.loadAllData();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
