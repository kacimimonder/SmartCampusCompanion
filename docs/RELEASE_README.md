# Release README — SmartCampus Companion

This file lists release artifacts and step-by-step build commands to generate Android and Web artifacts.

Artifacts to produce for final delivery:

- `release/smartcampus-<version>.zip` — contains APK/AAB, release notes, slides, technical report PDF, demo video.
- `build/web` — static web build (optional host).

Recommended release steps (local machine with Android SDK installed):

1. Update version in `pubspec.yaml`:

```bash
# edit pubspec.yaml: set version: 1.0.0+1

flutter pub get
```

2. Build Android debug APK (quick test):

```bash
flutter build apk --debug
# result: build/app/outputs/flutter-apk/app-debug.apk
```

3. Build Android release (unsigned AAB):

```bash
flutter build appbundle --release
# result: build/app/outputs/bundle/release/app-release.aab
```

4. Create a release keystore (if not already):

```bash
keytool -genkey -v -keystore release-keystore.jks -alias smartcampus -keyalg RSA -keysize 2048 -validity 10000
```

5. Configure `android/key.properties` and `android/app/build.gradle` signingConfigs per Flutter docs.

6. Build signed APK/AAB from Android Studio (recommended) or using Gradle CLI.

7. Package artifacts:

```bash
mkdir -p release
cp build/app/outputs/flutter-apk/app-release.apk release/smartcampus-1.0.0.apk
zip -r release/smartcampus-1.0.0.zip release/ docs/ build/web
```

Notes:

- Building final release requires Android SDK, proper keystore and environment variables (JAVA_HOME, ANDROID_HOME).
- For web hosting, upload `build/web` to any static host (Netlify, GitHub Pages, Azure Static Web Apps).
