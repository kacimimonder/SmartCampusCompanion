import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/app_settings.dart';

/// Persists user preferences in SharedPreferences and token in secure storage.
class SettingsRepository {
  SettingsRepository({
    SharedPreferences? preferences,
    FlutterSecureStorage? secureStorage,
  }) : _preferences = preferences,
       _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const String _notificationsKey = 'notifications_enabled';
  static const String _darkModeKey = 'dark_mode';
  static const String _languageKey = 'language';
  static const String _sessionTokenKey = 'session_token';

  final SharedPreferences? _preferences;
  final FlutterSecureStorage _secureStorage;

  Future<SharedPreferences> get _prefs async {
    return _preferences ?? SharedPreferences.getInstance();
  }

  Future<AppSettings> loadSettings() async {
    final prefs = await _prefs;

    return AppSettings(
      notificationsEnabled:
          prefs.getBool(_notificationsKey) ??
          AppSettings.defaults().notificationsEnabled,
      darkMode: prefs.getBool(_darkModeKey) ?? AppSettings.defaults().darkMode,
      language:
          prefs.getString(_languageKey) ?? AppSettings.defaults().language,
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await _prefs;

    await prefs.setBool(_notificationsKey, settings.notificationsEnabled);
    await prefs.setBool(_darkModeKey, settings.darkMode);
    await prefs.setString(_languageKey, settings.language);
  }

  Future<void> saveSessionToken(String token) {
    return _secureStorage.write(key: _sessionTokenKey, value: token);
  }

  Future<String?> getSessionToken() {
    return _secureStorage.read(key: _sessionTokenKey);
  }

  Future<void> clearSessionToken() {
    return _secureStorage.delete(key: _sessionTokenKey);
  }
}
