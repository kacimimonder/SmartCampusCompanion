import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/campus_local_datasource.dart';
import 'data/datasources/campus_remote_datasource.dart';
import 'data/repositories/campus_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'presentation/app_router.dart';
import 'presentation/viewmodels/dashboard_view_model.dart';
import 'presentation/viewmodels/settings_view_model.dart';

void main() {
  // Dependencies are composed at startup for a simple Clean Architecture-lite flow.
  final apiClient = const ApiClient();
  final remoteDataSource = CampusRemoteDataSource(apiClient);
  final localDataSource = CampusLocalDataSource();
  final repository = CampusRepository(
    remoteDataSource,
    localDataSource,
    Connectivity(),
  );
  final settingsRepository = SettingsRepository();
  final dashboardViewModel = DashboardViewModel(repository);
  final settingsViewModel = SettingsViewModel(settingsRepository);

  runApp(
    MainApp(
      dashboardViewModel: dashboardViewModel,
      settingsViewModel: settingsViewModel,
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({
    required DashboardViewModel dashboardViewModel,
    required SettingsViewModel settingsViewModel,
    super.key,
  }) : _dashboardViewModel = dashboardViewModel,
       _settingsViewModel = settingsViewModel;

  final DashboardViewModel _dashboardViewModel;
  final SettingsViewModel _settingsViewModel;

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(_dashboardViewModel, _settingsViewModel);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartCampus Companion',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: appRouter.onGenerateRoute,
    );
  }
}
