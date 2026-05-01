import 'package:flutter/material.dart';

import '../viewmodels/dashboard_view_model.dart';
import '../widgets/content_state_view.dart';

/// Home dashboard gives a quick summary of the student's campus day.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({required this.viewModel, super.key});

  final DashboardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading && viewModel.announcements.isEmpty) {
      return const ContentStateView(
        message: 'Loading campus dashboard...',
        isLoading: true,
      );
    }

    if (viewModel.errorMessage != null && viewModel.announcements.isEmpty) {
      return ContentStateView(
        message: viewModel.errorMessage!,
        onRetry: viewModel.loadAllData,
      );
    }

    final nextClass = viewModel.nextClass;

    return RefreshIndicator(
      onRefresh: () => viewModel.loadAllData(forceRefresh: true),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Today at a glance'),
          const SizedBox(height: 8),
          _DashboardSummaryCards(
            pendingCount: viewModel.pendingClassesCount,
            announcementCount: viewModel.announcements.length,
            eventCount: viewModel.events.length,
          ),
          const SizedBox(height: 16),
          _NextClassSection(nextClass: nextClass),
        ],
      ),
    );
  }
}

/// Extracted widget to prevent excessive rebuilds of summary cards.
class _DashboardSummaryCards extends StatelessWidget {
  const _DashboardSummaryCards({
    required this.pendingCount,
    required this.announcementCount,
    required this.eventCount,
  });

  final int pendingCount;
  final int announcementCount;
  final int eventCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Pending timetable items'),
            subtitle: Text('$pendingCount classes/tasks left'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.campaign_outlined),
            title: const Text('Announcements available'),
            subtitle: Text('$announcementCount updates from campus'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.event_available_outlined),
            title: const Text('Upcoming events loaded'),
            subtitle: Text('$eventCount event records fetched'),
          ),
        ),
      ],
    );
  }
}

/// Extracted widget for next class section.
class _NextClassSection extends StatelessWidget {
  const _NextClassSection({required this.nextClass});

  final dynamic nextClass;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Next class/task',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Card(
          child: ListTile(
            leading: Icon(
              nextClass == null ? Icons.info_outline : Icons.class_outlined,
            ),
            title: Text(nextClass?.title ?? 'No pending class right now'),
            subtitle: Text(
              nextClass == null ? 'All done for now.' : 'From timetable feed',
            ),
          ),
        ),
      ],
    );
  }
}
