import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Small wrapper around local_auth so biometric unlocking can be mocked or
/// replaced later without touching the presentation layer.
class BiometricService {
  BiometricService({LocalAuthentication? authentication})
    : _authentication = authentication ?? LocalAuthentication();

  final LocalAuthentication _authentication;

  Future<bool> authenticate() async {
    if (kIsWeb) {
      return false;
    }

    try {
      return _authentication.authenticate(
        localizedReason: 'Unlock SmartCampus Companion',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}
