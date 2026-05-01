# Android Studio Testing Guide

This guide explains how to run and test the SmartCampus Companion app using Android Studio and command-line helpers.

Prerequisites

- Android Studio (Arctic Fox or later recommended)
- Flutter SDK (match the project SDK; the repo used a local `flutter_sdk` junction during development)
- Android SDK / platform tools installed
- Java JDK (11+ recommended)

1. Open the project

- Launch Android Studio -> `Open` -> select the project folder: the repository root (the folder that contains `pubspec.yaml`).
- Android Studio will detect a Flutter project. If prompted, configure the Flutter SDK path (Point to your `flutter` installation).

2. Install packages

Open a terminal (inside Android Studio or system terminal) and run:

```bash
flutter pub get
flutter pub upgrade
```

3. Run on an emulator

- Start an Android emulator (AVD) from Android Studio's AVD Manager.
- In Android Studio select the desired device and press the green Run button, or run via terminal:

```bash
flutter run -d emulator-5554
```

4. Run on a physical device

- Enable Developer Options and USB Debugging on the device.
- Connect via USB and accept debugging prompt.
- Run from Android Studio or via terminal:

```bash
flutter devices
flutter run -d <device-id>
```

5. Grant runtime permissions (if testing camera/location)

- Use the Android emulator's extended controls or device settings to grant CAMERA / LOCATION permissions.

6. Run tests

In Android Studio: Right-click the `test/` folder -> Run 'All Tests'.

Or via terminal:

```bash
flutter test
```

7. Build debug APK quickly

```bash
flutter build apk --debug
# Install on device
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

8. Build release AAB (for Play Store)

Follow `docs/RELEASE_README.md` to create a keystore and configure signing. Then:

```bash
flutter build appbundle --release
```

9. Troubleshooting

- If Android Studio cannot find Flutter: File → Settings → Languages & Frameworks → Flutter → set Flutter SDK path.
- Gradle / dependencies errors: run `flutter pub get`, then `flutter clean` and rebuild.
- Plugin-specific issues (biometric, local notifications): test on a physical device; many plugins are no-op on web or have limited emulator support.

10. Quick checklist for the demo device

- Enable biometric hardware (or use emulator fingerprint support).
- Provide camera and location permissions.
- Toggle airplane mode for offline demonstration.

If you want, I can attempt to build a debug APK here and place it under `release/` — confirm and I will run `flutter build apk --debug` (this requires Android SDK on the runner machine).
