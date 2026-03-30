import 'package:flutter/material.dart';

import '../viewmodels/dashboard_view_model.dart';
import 'announcements_screen.dart';
import 'dashboard_screen.dart';
import 'events_screen.dart';
import 'settings_screen.dart';

/// Main shell that hosts bottom navigation and maps route names to tabs.
class HomeShell extends StatefulWidget {
  const HomeShell({
    required this.viewModel,
    this.initialIndex = 0,
    super.key,
  });

  final DashboardViewModel viewModel;
  final int initialIndex;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    // We trigger first fetch after first frame so build can complete smoothly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.viewModel.announcements.isEmpty &&
          widget.viewModel.events.isEmpty &&
          widget.viewModel.timetable.isEmpty) {
        widget.viewModel.loadAllData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('SmartCampus Companion'),
            actions: [
              IconButton(
                onPressed: widget.viewModel.loadAllData,
                tooltip: 'Refresh data',
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              DashboardScreen(viewModel: widget.viewModel),
              AnnouncementsScreen(viewModel: widget.viewModel),
              EventsScreen(viewModel: widget.viewModel),
              const SettingsScreen(),
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
