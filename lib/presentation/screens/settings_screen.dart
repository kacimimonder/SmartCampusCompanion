import 'package:flutter/material.dart';

import '../viewmodels/settings_view_model.dart';

/// Week 3 settings screen with persisted preferences and secure session controls.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.viewModel,
    required this.onOpenDeviceFeatures,
    super.key,
  });

  final SettingsViewModel viewModel;
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
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
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
                subtitle: Text('v0.3.0 - Week 3 + Week 4 build'),
              ),
            ),
          ],
        );
      },
    );
  }
}
