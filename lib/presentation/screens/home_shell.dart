import 'package:flutter/material.dart';

import '../../core/services/background_refresh_service.dart';
import '../app_router.dart';
import '../viewmodels/settings_view_model.dart';
import '../viewmodels/dashboard_view_model.dart';
import 'announcements_screen.dart';
import 'dashboard_screen.dart';
import 'events_screen.dart';
import 'settings_screen.dart';

/// Main shell that hosts bottom navigation and maps route names to tabs.
class HomeShell extends StatefulWidget {
  const HomeShell({
    required this.dashboardViewModel,
    required this.settingsViewModel,
    this.initialIndex = 0,
    super.key,
  });

  final DashboardViewModel dashboardViewModel;
  final SettingsViewModel settingsViewModel;
  final int initialIndex;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _selectedIndex;
  late final BackgroundRefreshService _backgroundRefreshService;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _backgroundRefreshService = BackgroundRefreshService(
      widget.dashboardViewModel,
    );

    // We trigger first fetch after first frame so build can complete smoothly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.dashboardViewModel.announcements.isEmpty &&
          widget.dashboardViewModel.events.isEmpty &&
          widget.dashboardViewModel.timetable.isEmpty) {
        widget.dashboardViewModel.loadAllData(forceRefresh: true);
      }
    });

    _backgroundRefreshService.start();
  }

  @override
  void dispose() {
    _backgroundRefreshService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.dashboardViewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('SmartCampus Companion'),
            actions: [
              IconButton(
                onPressed: () {
                  widget.dashboardViewModel.loadAllData(forceRefresh: true);
                },
                tooltip: 'Refresh data',
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: Column(
            children: [
              if (widget.dashboardViewModel.isOfflineMode)
                Container(
                  width: double.infinity,
                  color: const Color(0xFFFFE8A3),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    widget.dashboardViewModel.loadedFromCache
                        ? 'Offline mode: showing cached campus data.'
                        : 'Offline mode: no fresh data available.',
                  ),
                ),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    DashboardScreen(viewModel: widget.dashboardViewModel),
                    AnnouncementsScreen(viewModel: widget.dashboardViewModel),
                    EventsScreen(viewModel: widget.dashboardViewModel),
                    SettingsScreen(
                      viewModel: widget.settingsViewModel,
                      onOpenDeviceFeatures: () {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.deviceFeatures);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.campaign_outlined),
                selectedIcon: Icon(Icons.campaign),
                label: 'Announcements',
              ),
              NavigationDestination(
                icon: Icon(Icons.event_outlined),
                selectedIcon: Icon(Icons.event),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
