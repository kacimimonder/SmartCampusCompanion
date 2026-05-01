import 'package:flutter/material.dart';

import '../../core/services/notification_service.dart';
import '../viewmodels/dashboard_view_model.dart';
import '../viewmodels/settings_view_model.dart';

/// Week 3 settings screen with persisted preferences and secure session controls.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.viewModel,
    required this.dashboardViewModel,
    required this.onOpenDeviceFeatures,
    super.key,
  });

  final SettingsViewModel viewModel;
  final DashboardViewModel dashboardViewModel;
  final VoidCallback onOpenDeviceFeatures;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();

    // Load persisted settings and secure token state when opening settings.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final settings = widget.viewModel.settings;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Card(
              child: SwitchListTile(
                value: settings.notificationsEnabled,
                onChanged: widget.viewModel.setNotificationsEnabled,
                title: const Text('Notifications'),
                subtitle: const Text('Persisted with SharedPreferences'),
              ),
            ),
            Card(
              child: SwitchListTile(
                value: settings.darkMode,
                onChanged: widget.viewModel.setDarkMode,
                title: const Text('Dark mode preference'),
                subtitle: const Text('Persisted with SharedPreferences'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('Language'),
                subtitle: Text('Current: ${settings.language.toUpperCase()}'),
                trailing: DropdownButton<String>(
                  value: settings.language,
                  underline: const SizedBox.shrink(),
                  onChanged: (value) {
                    if (value != null) {
                      widget.viewModel.setLanguage(value);
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('EN')),
                    DropdownMenuItem(value: 'fr', child: Text('FR')),
                    DropdownMenuItem(value: 'ar', child: Text('AR')),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Secure Session Token Demo'),
                subtitle: Text(
                  widget.viewModel.hasSessionToken
                      ? 'Token is stored securely on this device.'
                      : 'No token stored in secure storage.',
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.fingerprint),
                title: const Text('Biometric Unlock Demo'),
                subtitle: Text(
                  widget.viewModel.biometricUnlocked
                      ? 'Biometric session unlocked for this run.'
                      : 'Use device biometrics to unlock the session.',
                ),
                trailing: FilledButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final success = await widget.viewModel
                        .authenticateWithBiometrics();

                    if (!mounted) {
                      return;
                    }

                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Biometric unlock succeeded.'
                              : 'Biometric unlock is unavailable on this device.',
                        ),
                      ),
                    );
                  },
                  child: const Text('Unlock'),
                ),
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final reminderTime = DateTime.now().add(
                      const Duration(minutes: 1),
                    );
                    await NotificationService().scheduleReminder(
                      id: 1001,
                      scheduledDate: reminderTime,
                      title: 'Campus reminder',
                      body: 'Your demo campus reminder is ready to open.',
                      route: '/events',
                      extra: {'source': 'settings_demo'},
                    );

                    if (!mounted) {
                      return;
                    }

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Demo reminder scheduled for 1 minute.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('Schedule Demo Reminder'),
                ),
                FilledButton.icon(
                  onPressed: widget.viewModel.saveDemoSessionToken,
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Save Demo Token'),
                ),
                OutlinedButton.icon(
                  onPressed: widget.viewModel.clearSession,
                  icon: const Icon(Icons.logout),
                  label: const Text('Clear Session'),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      final filePath = await widget.viewModel
                          .exportTimetableSchedule(
                            widget.dashboardViewModel.timetable,
                          );
                      if (!mounted) return;
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('Schedule exported to: $filePath'),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('Export failed: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.file_download_outlined),
                  label: const Text('Export Schedule'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone_android_outlined),
                title: const Text('Week 4 Device Features'),
                subtitle: const Text(
                  'Permissions + Location + Camera/Gallery + Sensors demo',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: widget.onOpenDeviceFeatures,
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Version'),
                subtitle: Text('v0.4.0 - Week 5 notifications build'),
              ),
            ),
          ],
        );
      },
    );
  }
}
