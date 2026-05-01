# SmartCampus Companion — Technical Report (Draft)

## Executive Summary

This document summarizes the architecture, implementation choices, testing, and deployment steps for the SmartCampus Companion mobile app (Flutter). It accompanies the final delivery artifacts: demo video, slide deck, and release package.

## Table of Contents

- Executive Summary
- Architecture Overview
- Key Components
- Data Flow & Sync Strategy
- Offline Behavior
- Notifications & Background Refresh
- Security & Biometric Demo
- Testing & QA
- Performance Considerations
- Build & Release
- Limitations and Future Work
- Appendix: How to reproduce builds and profiling

## Architecture Overview

The app uses a lightweight Clean-Architecture layering:

- Presentation: Flutter UI, ChangeNotifier viewmodels
- Domain: models and business rules
- Data: remote (HTTP) + local (SQLite) datasources and repositories

Key packages: http, connectivity_plus, sqflite (+ web factory), shared_preferences, flutter_secure_storage, flutter_local_notifications (mobile), local_auth, timezone.

## Key Components

- NotificationService — schedules local reminders and deep-link handling.
- BackgroundRefreshService — in-app periodic refresh with freshness/throttle guard.
- BiometricService — wrapper around local_auth for demo unlock flows.
- LocalDatabase — sqflite wrapper with web-factory initialization for web builds.
- Repositories: offline-first orchestration (connectivity -> remote -> cache fallback).

## Data Flow & Sync Strategy

- On foreground/resume, `DashboardViewModel.loadAllData(forceRefresh: false)` attempts a refresh if cached data is stale (> freshness window).
- Background refresh uses a throttled periodic loop while the app is active (documented limitations for background execution across platforms).

## Offline Behavior

- All remote data endpoints are cached in local DB tables (announcements, events, timetable). Repository methods fall back to cached data when the network is unavailable.

## Notifications & Background Refresh

- Local notifications are scheduled with timezone-aware `zonedSchedule` calls; NotificationService includes web no-op branches to avoid plugin errors on web builds.
- True platform background tasks (Android WorkManager / iOS background fetch) were documented but not implemented (future work).

## Security & Biometric Demo

- Biometric demo demonstrates biometric auth to unlock a locally stored demo session token in `flutter_secure_storage`. This is a demo flow; a full auth server integration is not implemented.

## Testing & QA

- Unit tests added for `ApiClient` and `CampusRemoteDataSource` covering JSON parsing and client behavior. Run with:

```bash
flutter test
```

## Performance Considerations

- Refresh throttling prevents rapid repeated network calls.
- Consider adding database indices and image resizing to improve memory and CPU usage.

## Build & Release

- Web: `flutter build web` (produces `build/web`). A static server is sufficient for hosting.
- Android: see `docs/RELEASE_README.md` for step-by-step build guidance (keystore, versioning, AAB vs APK).

## Limitations and Future Work

- Full server-side authentication not implemented.
- Platform background fetch is not implemented (would require platform-specific WorkManager / BGFetch integration).

## Appendix: Reproduce builds & profiling

1. Ensure `flutter` is installed and the `flutter` SDK path is configured in Android Studio or terminal.
2. Run `flutter pub get` then `flutter analyze`.
3. Web build: `flutter build web`.
4. Android debug: `flutter build apk --debug` or build from Android Studio (see `docs/ANDROID_STUDIO_TESTING_GUIDE.md`).

Placeholders: add screenshots, profiling CSVs, and timings before exporting this to PDF.
