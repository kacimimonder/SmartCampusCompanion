# SmartCampus Companion - Project Specification and Technical Implementation Plan

## 1. Purpose

This document consolidates the project requirements, maps them to mobile operating system concepts, and defines how each feature is or will be implemented in technical terms.

Current execution state:
- Week 1 completed
- Week 2 completed
- Week 3 completed
- Week 4 completed
- Weeks 5 to 8 planned

## 2. Architecture Baseline

Chosen style:
- Clean Architecture-lite with Presentation, Domain, and Data layers

Current structure:
- Presentation: screens, routing, view models
- Domain: app models/entities
- Data: remote data source, local data source, repositories
- Core: API client, theme, local database

State management:
- ChangeNotifier view models (DashboardViewModel and SettingsViewModel)

Data flow:
1. UI calls view model action.
2. View model requests data from repository.
3. Repository checks connectivity and chooses remote or local source.
4. Repository returns domain models to view model.
5. View model notifies UI for loading/success/error/offline states.

## 3. Requirement Coverage Matrix

| Requirement Area | Required by Specification | Current Status | Technical Notes |
|---|---|---|---|
| Authentication and security model | Email/password login, secure token storage, biometrics unlock, logout/session invalidation | Partially implemented | Secure token persistence and clear session are present; login API and biometric unlock are planned for Week 6 |
| Networking and offline-first | REST fetch, online/offline support, loading/error/offline UI states | Implemented for Week 2-3 scope | Uses HTTP + repository fallback to SQLite cache |
| Data types | Announcements, Events, Timetable | Implemented | Parsed from JSONPlaceholder endpoints and cached locally |
| Local persistence | SharedPreferences, secure storage, DB cache, file export as JSON | Mostly implemented | SharedPreferences + secure storage + SQLite completed; schedule export JSON planned |
| Navigation and UX | Minimum screens and named routes | Implemented | Home, Announcements, Events, Settings, and Device Features screen |
| Accessibility baseline | Readable typography, contrast, meaningful labels | Basic implementation present | Will strengthen semantics, text scale checks, and color contrast validation |
| Device integration and permissions | At least two runtime-permission features | Implemented (3 features) | Location, camera/gallery, and accelerometer demo |
| Notifications and background execution | Scheduled local notification and deep-link tap action, periodic background refresh | Planned | Week 5 implementation target |
| Performance and profiling | At least two DevTools-driven optimizations with before/after report | Planned | Week 6 profiling and technical report evidence |

## 4. Implemented Scope (Weeks 1-4)

## 4.1 Week 1 - Navigation Skeleton

Implemented:
- App shell with bottom navigation
- Named routes and route generator (onGenerateRoute)
- Main screens scaffolded

Technical details:
- Router centralization through AppRouter
- Route constants to avoid hardcoded strings
- HomeShell uses IndexedStack for tab persistence

## 4.2 Week 2 - Core Data and Networking

Implemented:
- Domain models for announcements, events, and timetable items
- REST integration using HTTP client
- Error-aware API wrapper with timeout and payload validation

Technical details:
- Endpoints:
  - /posts -> announcements
  - /albums -> events
  - /todos -> timetable
- ApiClient validates HTTP status and JSON list shape
- View model surfaces loading and user-facing error state

## 4.3 Week 3 - Persistence and Offline-First

Implemented:
- SQLite local cache for structured content
- SharedPreferences for user settings
- FlutterSecureStorage for session token
- Offline mode banner and cache fallback

Technical details:
- LocalDatabase creates tables: announcements, events, timetable
- CampusLocalDataSource handles cache write/read operations
- CampusRepository checks connectivity and applies fallback order:
  1. Remote fetch when online
  2. Cache read if remote fails
  3. Cache read when offline
  4. Explicit error when cache is empty and offline

## 4.4 Week 4 - Permissions and Device Features

Implemented:
- Runtime location permission flow and nearest-POI calculation
- Runtime camera/gallery permission flow and image attachment preview
- Accelerometer stream demo for sensor integration
- Android and iOS permission declarations

Technical details:
- permission_handler for runtime permission requests and denial handling
- geolocator for current position and distance calculation
- image_picker for camera/gallery attachment
- sensors_plus for accelerometer stream readings

## 5. Remaining Work Plan (Weeks 5-8)

## 5.1 Week 5 - Notifications and Background Execution

Planned implementation:
- Add flutter_local_notifications package
- Configure Android notification channel and iOS permission flow
- Schedule at least one local reminder (example: 10 minutes before class)
- Add payload-based deep-link navigation (tap notification -> open target screen)
- Add periodic refresh strategy for announcements

Technical approach:
1. Create NotificationService with initialization and scheduling methods.
2. Define payload schema (for example: {"route":"/events","id":123}).
3. Parse payload in notification tap callback and route via AppRouter.
4. Use lightweight periodic background refresh strategy suitable for Flutter constraints.
5. Persist last refresh time and result state to avoid duplicate sync work.

## 5.2 Week 6 - Security Hardening and Biometrics

Planned implementation:
- Add local_auth for biometric unlock after first successful login
- Add session timeout/expiration handling
- Improve security posture against common OWASP mobile risks

Technical approach:
1. Add AuthRepository for login/session lifecycle.
2. Save only token and minimal metadata in secure storage.
3. Add BiometricGate screen shown on app resume if session is active.
4. Enforce token invalidation on logout and expiration checks.
5. Document threat considerations (sensitive logging, insecure storage, weak auth flow).

## 5.3 Week 6 - Performance Profiling

Planned improvements with measurable evidence:
- Improvement A: reduce unnecessary rebuilds in tab screens
- Improvement B: optimize list rendering for large data sets

Measurement approach:
1. Record baseline metrics in DevTools (frame chart, rebuild counts).
2. Apply optimization (const widgets, smaller rebuild scope, list item optimizations).
3. Re-measure and capture before/after screenshots.
4. Report impact in technical report with concrete numbers.

## 5.4 Week 7 - Testing and Final Stabilization

Planned implementation:
- Unit tests for repository logic and JSON parsing
- Failure-path tests for offline fallback and empty-cache behavior
- Regression pass for permission denial flows and session controls

Technical approach:
- Add test doubles/mocks for remote data source and local cache
- Validate repository decision branches (online success/failure/offline)
- Validate settings persistence and secure token behavior

## 5.5 Week 8 - Delivery Packaging

Planned outputs:
- Final source code and clean commit history
- 8-15 page technical report
- 3-6 minute demo video
- 5-minute final presentation

## 6. Mobile OS Concept Mapping

| Implemented/Planned Feature | Mobile OS Concept |
|---|---|
| App lifecycle refresh hooks (planned finalization) | Lifecycle management (paused/resumed) |
| Runtime permission prompts and denial handling | Permissions model |
| SQLite + preferences + secure storage | Storage and sandboxing |
| REST integration + timeout + offline fallback | Networking and connectivity awareness |
| Local scheduled notifications and deep links (planned) | Notification subsystem |
| Periodic data refresh (planned) | Background execution model |
| Secure token storage + biometrics (planned) | Security model |
| DevTools optimization report (planned) | Performance profiling |

## 7. Package Decisions

Already integrated:
- http
- connectivity_plus
- sqflite
- path
- shared_preferences
- flutter_secure_storage
- permission_handler
- geolocator
- image_picker
- sensors_plus

Planned additions:
- flutter_local_notifications
- local_auth

## 8. Minimum Passing Criteria Check

Required minimum:
- Authentication
- Offline caching
- 2 or more device features with permissions
- Local notifications
- Written OS concept mapping

Current status versus minimum:
- Offline caching: completed
- Device features with permissions: completed (location, camera/gallery, sensors)
- Written OS mapping: completed in docs
- Authentication: partially complete (secure token exists; full login/biometric pending)
- Local notifications: pending (Week 5)

## 9. Suggested Commit Organization Going Forward

Recommended sequence for remaining milestones:
1. feat: implement week5 local notifications and deep link handling
2. feat: add week5 background refresh workflow
3. feat: implement week6 biometric unlock and auth session hardening
4. perf: optimize rebuilds and list rendering with devtools evidence
5. test: add repository and parsing unit tests
6. docs: finalize technical report assets and architecture mapping

This order keeps history clear and aligned with milestone-based evaluation.
