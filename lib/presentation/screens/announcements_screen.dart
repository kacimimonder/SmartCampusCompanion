import 'package:flutter/material.dart';

import '../viewmodels/dashboard_view_model.dart';
import '../widgets/content_state_view.dart';

/// Shows announcement list fetched from remote REST source.
class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({required this.viewModel, super.key});

  final DashboardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading && viewModel.announcements.isEmpty) {
      return const ContentStateView(
        message: 'Loading announcements...',
        isLoading: true,
      );
    }

    if (viewModel.errorMessage != null && viewModel.announcements.isEmpty) {
      return ContentStateView(
        message: viewModel.errorMessage!,
        onRetry: viewModel.loadAllData,
      );
    }

    if (viewModel.announcements.isEmpty) {
      return const ContentStateView(message: 'No announcements available yet.');
    }

    return RefreshIndicator(
      onRefresh: viewModel.loadAllData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.announcements.length,
        itemBuilder: (context, index) {
          final announcement = viewModel.announcements[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.campaign_outlined),
              title: Text(announcement.title),
              subtitle: Text(
                announcement.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}
