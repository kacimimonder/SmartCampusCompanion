# SmartCampus Companion - Final Delivery Checklist

## Purpose

This checklist summarizes what remains for the final submission package and how to assemble it cleanly from the current codebase.

## Completed Core Work

- Week 1: Navigation skeleton
- Week 2: Networking core and domain models
- Week 3: Offline persistence, secure storage, and settings
- Week 4: Permissions and device integrations
- Week 5: Local notifications, deep-linking, and background refresh
- Week 6: Biometric unlock and performance throttling
- Week 7: Repository/parsing tests

## Week 8 Remaining Deliverables

### 1. Technical Report (8-15 pages)

Include these sections:

- Project overview and objective
- Functional requirements mapping
- Architecture overview (Presentation, Domain, Data, Core)
- Mobile OS concept mapping
- Offline-first design and cache flow
- Device permissions and sensor usage
- Notification and background refresh design
- Security design: secure storage and biometrics
- Performance observations and optimizations
- Testing summary
- Limitations and future work

Suggested evidence to capture:

- App screenshots for each major screen
- Offline banner / cached-content screenshot
- Notification scheduling screen
- Biometric unlock screen
- Test output summary
- Any DevTools screenshots used for performance discussion

### 2. Demo Video (3-6 minutes)

Suggested walkthrough order:

1. Open app and show dashboard.
2. Navigate between Home, Announcements, Events, and Settings.
3. Show offline mode or explain cache fallback.
4. Demonstrate device features screen.
5. Show reminder scheduling and tap-deep-link flow.
6. Show biometric unlock demo.
7. Briefly mention tests and performance work.

### 3. Presentation (5 minutes)

Slide outline:

- Problem and goals
- Architecture and stack
- Week-by-week implementation summary
- OS concept mapping
- Demo highlights
- Risks, limitations, and future work

### 4. Repository Cleanup

Before submission:

- Confirm `flutter analyze` passes
- Confirm repository tests pass
- Ensure commit history is milestone-readable
- Review docs for outdated week labels
- Verify no temporary debug code remains

## Source Files to Reference in the Report

- `lib/main.dart`
- `lib/presentation/app_router.dart`
- `lib/presentation/screens/home_shell.dart`
- `lib/presentation/screens/settings_screen.dart`
- `lib/presentation/screens/device_features_screen.dart`
- `lib/presentation/viewmodels/dashboard_view_model.dart`
- `lib/presentation/viewmodels/settings_view_model.dart`
- `lib/core/services/notification_service.dart`
- `lib/core/services/background_refresh_service.dart`
- `lib/core/services/biometric_service.dart`
- `lib/data/repositories/campus_repository.dart`
- `lib/data/datasources/campus_local_datasource.dart`
- `test/api_client_test.dart`
- `test/campus_remote_data_source_test.dart`

## Submission Readiness Check

- Code builds cleanly
- Tests pass
- Documentation reflects implemented scope
- Demo flow is rehearsed
- Slides and report are exported to final formats
