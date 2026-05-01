import 'package:flutter/material.dart';

import '../viewmodels/dashboard_view_model.dart';
import '../widgets/content_state_view.dart';

/// Shows campus events fetched from REST API.
class EventsScreen extends StatelessWidget {
  const EventsScreen({required this.viewModel, super.key});

  final DashboardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading && viewModel.events.isEmpty) {
      return const ContentStateView(
        message: 'Loading events...',
        isLoading: true,
      );
    }

    if (viewModel.errorMessage != null && viewModel.events.isEmpty) {
      return ContentStateView(
        message: viewModel.errorMessage!,
        onRetry: () => viewModel.loadAllData(forceRefresh: true),
      );
    }

    if (viewModel.events.isEmpty) {
      return const ContentStateView(message: 'No events available right now.');
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.loadAllData(forceRefresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.events.length,
        itemBuilder: (context, index) {
          final event = viewModel.events[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.event_outlined),
              title: Text(event.title),
              subtitle: Text('Event ID: ${event.id}'),
            ),
          );
        },
      ),
    );
  }
}
