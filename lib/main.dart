import 'package:flutter/material.dart';

import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/campus_remote_datasource.dart';
import 'data/repositories/campus_repository.dart';
import 'presentation/app_router.dart';
import 'presentation/viewmodels/dashboard_view_model.dart';

void main() {
  // Dependencies are composed at startup for a simple Clean Architecture-lite flow.
  final apiClient = const ApiClient();
  final remoteDataSource = CampusRemoteDataSource(apiClient);
  final repository = CampusRepository(remoteDataSource);
  final viewModel = DashboardViewModel(repository);

  runApp(MainApp(viewModel: viewModel));
}

class MainApp extends StatelessWidget {
  const MainApp({required DashboardViewModel viewModel, super.key})
      : _viewModel = viewModel;

  final DashboardViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(_viewModel);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartCampus Companion',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: appRouter.onGenerateRoute,
    );
  }
}
