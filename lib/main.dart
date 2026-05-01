import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'core/network/api_client.dart';
import 'core/services/biometric_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/campus_local_datasource.dart';
import 'data/datasources/campus_remote_datasource.dart';
import 'data/repositories/campus_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'presentation/app_router.dart';
import 'presentation/viewmodels/dashboard_view_model.dart';
import 'presentation/viewmodels/settings_view_model.dart';

Future<void> main() async {
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
  final biometricService = BiometricService();
  final dashboardViewModel = DashboardViewModel(repository);
  final settingsViewModel = SettingsViewModel(
    settingsRepository,
    biometricService,
  );

  // Create a navigator key so services can deep-link into the app on
  // notification tap actions.
  final navigatorKey = GlobalKey<NavigatorState>();

  // Initialize notification service before runApp so scheduled demo
  // reminders can be created early if needed.
  final notificationService = NotificationService(navigatorKey: navigatorKey);
  await notificationService.init();

  runApp(
    MainApp(
      dashboardViewModel: dashboardViewModel,
      settingsViewModel: settingsViewModel,
      navigatorKey: navigatorKey,
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({
    required DashboardViewModel dashboardViewModel,
    required SettingsViewModel settingsViewModel,
    required this.navigatorKey,
    super.key,
  }) : _dashboardViewModel = dashboardViewModel,
       _settingsViewModel = settingsViewModel;

  final DashboardViewModel _dashboardViewModel;
  final SettingsViewModel _settingsViewModel;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(_dashboardViewModel, _settingsViewModel);

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'SmartCampus Companion',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: appRouter.onGenerateRoute,
    );
  }
}
