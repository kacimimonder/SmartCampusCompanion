import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'viewmodels/dashboard_view_model.dart';

/// Named route constants keep route usage type-safe and easy to refactor.
class AppRoutes {
  static const String home = '/';
  static const String announcements = '/announcements';
  static const String events = '/events';
  static const String settings = '/settings';
}

/// Route generator centralizes navigation policy and tab mapping.
class AppRouter {
  const AppRouter(this._viewModel);

  final DashboardViewModel _viewModel;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return _materialRoute(HomeShellIndex.home, settings);
      case AppRoutes.announcements:
        return _materialRoute(HomeShellIndex.announcements, settings);
      case AppRoutes.events:
        return _materialRoute(HomeShellIndex.events, settings);
      case AppRoutes.settings:
        return _materialRoute(HomeShellIndex.settings, settings);
      default:
        return _materialRoute(HomeShellIndex.home, settings);
    }
  }

  MaterialPageRoute<void> _materialRoute(
    HomeShellIndex index,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => HomeShell(viewModel: _viewModel, initialIndex: index.value),
    );
  }
}

/// Small helper type avoids magic numbers while selecting a tab.
class HomeShellIndex {
  const HomeShellIndex._(this.value);

  final int value;

  static const HomeShellIndex home = HomeShellIndex._(0);
  static const HomeShellIndex announcements = HomeShellIndex._(1);
  static const HomeShellIndex events = HomeShellIndex._(2);
  static const HomeShellIndex settings = HomeShellIndex._(3);
}
