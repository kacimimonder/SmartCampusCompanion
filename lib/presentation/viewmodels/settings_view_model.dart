import 'package:flutter/foundation.dart';

import '../../core/services/biometric_service.dart';
import '../../core/services/schedule_export_service.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/models/app_settings.dart';
import '../../domain/models/timetable_item.dart';

/// ViewModel for settings and secure session token actions.
class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel(this._settingsRepository, this._biometricService);

  final SettingsRepository _settingsRepository;
  final BiometricService _biometricService;

  AppSettings _settings = AppSettings.defaults();
  bool _isLoading = false;
  String? _sessionToken;
  bool _biometricUnlocked = false;

  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get sessionToken => _sessionToken;
  bool get hasSessionToken => (_sessionToken ?? '').isNotEmpty;
  bool get biometricUnlocked => _biometricUnlocked;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _settings = await _settingsRepository.loadSettings();
    _sessionToken = await _settingsRepository.getSessionToken();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _settings = _settings.copyWith(notificationsEnabled: value);
    notifyListeners();
    await _settingsRepository.saveSettings(_settings);
  }

  Future<void> setDarkMode(bool value) async {
    _settings = _settings.copyWith(darkMode: value);
    notifyListeners();
    await _settingsRepository.saveSettings(_settings);
  }

  Future<void> setLanguage(String value) async {
    _settings = _settings.copyWith(language: value);
    notifyListeners();
    await _settingsRepository.saveSettings(_settings);
  }

  Future<void> saveDemoSessionToken() async {
    // Week 3 security demo: token is persisted in encrypted secure storage.
    const token = 'demo_session_token_week3';
    await _settingsRepository.saveSessionToken(token);
    _sessionToken = token;
    notifyListeners();
  }

  Future<void> clearSession() async {
    await _settingsRepository.clearSessionToken();
    _sessionToken = null;
    _biometricUnlocked = false;
    notifyListeners();
  }

  Future<bool> authenticateWithBiometrics() async {
    final authenticated = await _biometricService.authenticate();
    _biometricUnlocked = authenticated;
    notifyListeners();
    return authenticated;
  }

  /// Exports timetable items to a JSON file.
  /// Takes a list of timetable items and returns the file path.
  Future<String> exportTimetableSchedule(
    List<TimetableItem> timetableItems,
  ) async {
    final exportService = ScheduleExportService();
    return await exportService.exportTimetableAsJson(timetableItems);
  }
}
