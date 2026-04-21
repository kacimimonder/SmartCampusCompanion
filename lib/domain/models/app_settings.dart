/// User-configurable preferences persisted locally for offline availability.
class AppSettings {
  const AppSettings({
    required this.notificationsEnabled,
    required this.darkMode,
    required this.language,
  });

  final bool notificationsEnabled;
  final bool darkMode;
  final String language;

  /// Sensible defaults used on first app launch.
  factory AppSettings.defaults() {
    return const AppSettings(
      notificationsEnabled: true,
      darkMode: false,
      language: 'en',
    );
  }

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? darkMode,
    String? language,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
    );
  }
}
