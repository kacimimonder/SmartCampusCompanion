import 'package:flutter/material.dart';

/// Reusable widget for loading/error/empty states to keep screen code concise.
class ContentStateView extends StatelessWidget {
  const ContentStateView({
    required this.message,
    this.isLoading = false,
    this.onRetry,
    super.key,
  });

  final String message;
  final bool isLoading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) const CircularProgressIndicator(),
            if (isLoading) const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (!isLoading && onRetry != null) const SizedBox(height: 12),
            if (!isLoading && onRetry != null)
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }
}
