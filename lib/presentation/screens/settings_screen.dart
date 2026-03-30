import 'package:flutter/material.dart';

/// Week 1 settings mockup: UI skeleton for preferences to be persisted later.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Local state is temporary for Week 1-2. Week 3 will persist these values.
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Card(
          child: SwitchListTile(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            title: const Text('Notifications'),
            subtitle: const Text('Enable reminders and campus alerts'),
          ),
        ),
        Card(
          child: SwitchListTile(
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
            title: const Text('Dark mode (UI mockup)'),
            subtitle: const Text('Theme persistence comes in Week 3'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('v0.1.0 - Week 1 + Week 2 build'),
          ),
        ),
      ],
    );
  }
}
