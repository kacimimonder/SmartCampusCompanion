# SmartCampus Companion - Overview and Technical Deep Dive

## 1. Project Overview

SmartCampus Companion is a mobile app for students to quickly access campus announcements, events, and timetable-related tasks.

This implementation currently covers Week 1 through Week 4 milestones:

- Week 1: Project initiation, UI skeleton, and route/navigation setup.
- Week 2: Core logic with domain models and REST API integration.
- Week 3: Local persistence, repository caching, and offline-first behavior.
- Week 4: Runtime permissions and device feature integrations.

### Current User Flows (Week 1-4)

1. User opens the app and lands on the Dashboard.
2. App fetches campus-related content from REST endpoints.
3. User navigates between Home, Announcements, Events, and Settings.
4. User can pull-to-refresh or press the refresh icon to reload data.
5. If network is unavailable, user can continue browsing cached content (offline mode).
6. User can manage persisted settings and secure session token in Settings.
7. User can open Device Features Lab and test location/camera/gallery/sensor flows.

## 2. Functional Scope Implemented

- Named-route navigation using `onGenerateRoute`.
- Four main screens:
  - Home (Dashboard)
  - Announcements
  - Events
  - Settings
- Domain models:
  - `Announcement`
  - `EventItem`
  - `TimetableItem`
- Networking layer using `http` and JSONPlaceholder.
- Local SQLite cache for announcements, events, and timetable.
- Settings persistence via `shared_preferences` and secure token via `flutter_secure_storage`.
- Connectivity-aware offline banner and cache fallback behavior.
- Device Features Lab screen with runtime permission requests.
- Location integration with nearest campus POI calculation.
- Camera/Gallery image picking and accelerometer stream demo.
- Basic loading, error, and offline UI states.
- Refresh pattern (`RefreshIndicator` + top AppBar action).

## 3. Architecture (Clean Architecture-lite)

The app uses a lightweight layered architecture to keep responsibilities separated.

### 3.1 Presentation Layer

Files under `lib/presentation/`.

Responsibilities:

- Build UI widgets and screens.
- Handle route generation.
- Observe and render state from the ViewModel.

Key components:

- `HomeShell`: Root scaffold + bottom navigation.
- `DashboardScreen`, `AnnouncementsScreen`, `EventsScreen`, `SettingsScreen`, `DeviceFeaturesScreen`.
- `DashboardViewModel`: Loads and stores app-facing state.
- `SettingsViewModel`: Persists and exposes settings/session-token state.
- `ContentStateView`: Reusable widget for loading/error/empty states.

### 3.2 Domain Layer

Files under `lib/domain/models/`.

Responsibilities:

- Define stable, app-centric entities.
- Avoid UI or networking dependencies.

Key models:

- `Announcement`
- `EventItem`
- `TimetableItem`
- `CampusDataBundle`
- `AppSettings`

### 3.3 Data Layer

Files under `lib/data/` and `lib/core/network/`.

Responsibilities:

- Perform REST calls.
- Parse JSON payloads.
- Expose data through repository abstraction.

Key components:

- `ApiClient`: HTTP GET wrapper with timeout and response validation.
- `CampusRemoteDataSource`: Endpoint-specific data fetching logic.
- `CampusLocalDataSource`: SQLite caching layer.
- `CampusRepository`: Offline-first orchestration (network + cache fallback).
- `SettingsRepository`: SharedPreferences + secure storage persistence.

## 4. Technical In-Depth

### 4.1 App Startup and Dependency Composition

In `lib/main.dart`, dependencies are manually wired in `main()`:

1. `ApiClient` is created.
2. `CampusRemoteDataSource` is created using `ApiClient`.
3. `CampusLocalDataSource` is created for SQLite cache access.
4. `CampusRepository` is created with remote source, local source, and connectivity.
5. `SettingsRepository` is created for preferences and secure token storage.
6. `DashboardViewModel` and `SettingsViewModel` are created.
7. `MaterialApp` is launched with a route generator.

This explicit composition is simple and suitable for this stage. In later weeks, this can migrate to a dependency injection package.

### 4.2 Navigation Strategy

Navigation is centralized in `lib/presentation/app_router.dart`:

- Routes:
  - `/`
  - `/announcements`
  - `/events`
  - `/settings`
  - `/device-features`
- `onGenerateRoute` maps route names to `HomeShell` with the selected tab index.

Why this approach:

- Keeps navigation rules in one place.
- Makes future deep-linking easier (important for notification tap actions in later weeks).

### 4.3 Networking and Error Handling

`ApiClient.getList()` performs:

1. URI construction from `ApiConstants.baseUrl`.
2. HTTP GET request with timeout.
3. HTTP status code validation (must be 2xx).
4. JSON decoding and payload shape validation (must be a list).

Failure behavior:

- Throws `ApiException` for status errors or invalid payload shape.
- `DashboardViewModel` catches errors and sets user-facing error messages.

### 4.4 Offline-First Repository Flow (Week 3)

`CampusRepository.getDashboardData()` follows this strategy:

1. Check connectivity status.
2. If online, fetch remote data in parallel and cache it in SQLite.
3. If online fetch fails or if offline, read cached content from SQLite.
4. If no cache exists while offline, throw an explicit error.

This ensures usable behavior during network interruptions while preserving fresh data when network is available.

### 4.5 State Management Flow

Current state management uses Flutter's `ChangeNotifier`:

- `DashboardViewModel.loadAllData()` consumes one repository bundle and updates:
  - loaded lists
  - loading/error states
  - offline/cache status flags
- State updates:
  - `_isLoading = true` before request.
  - Data lists updated on success.
  - `_errorMessage` set on failure.
  - `notifyListeners()` after each major change.

UI reaction:

- Screens rebuild via `AnimatedBuilder` in `HomeShell`.
- A top offline banner appears when cached/offline mode is active.
- Each screen decides whether to show loading, error, empty, or data list views.

### 4.6 Week 4 Device Integrations

- **Location**: requests runtime location permission, fetches current coordinates, and computes nearest campus POI.
- **Camera/Gallery**: requests runtime permission and allows selecting or capturing image attachments.
- **Sensors (accelerometer)**: reads user accelerometer stream and displays motion magnitude in real time.

### 4.7 Why JSONPlaceholder Endpoints Were Chosen

For Week 2 networking validation:

- `/posts` -> announcements
- `/albums` -> events
- `/todos` -> timetable items

This gives realistic JSON parsing paths and supports offline-first expansion in Week 3 via caching.

## 5. Mobile OS Concepts Mapped (Week 1-4)

Implemented now:

- Networking: REST calls with timeout and failure handling.
- UI + Navigation: multi-screen app structure and route management.
- Storage & Sandboxing: SQLite cache + SharedPreferences + secure token storage.
- Permissions Model: runtime camera/gallery/location permission requests with denial handling.
- Sensors: accelerometer stream demo.

Planned for upcoming weeks:

- Notifications and background work.
- Security hardening and biometrics.
- Performance profiling and optimization report.

## 6. Code Quality Notes

- Code is organized by layer to reduce coupling.
- Naming is explicit and domain-oriented.
- Each class/file includes comments describing purpose and behavior.
- Shared widgets reduce duplicated state UI code.

## 7. How to Run

From the `smart_campus_companion` folder:

```bash
flutter pub get
flutter run
```

## 8. Next Steps (Week 5+)

1. Configure local notifications and schedule class/event reminders.
2. Add deep-link/tap action routing from notification payloads.
3. Implement background refresh tasks for announcements.
4. Add biometric unlock flow after first login session.
5. Profile performance with DevTools and document optimization evidence.

## 9. Companion Planning Document

For complete requirement coverage and technical implementation planning (Weeks 1-8), see:

- `docs/PROJECT_SPEC_AND_IMPLEMENTATION_PLAN.md`
- `docs/AGENT_EXECUTION_PLAYBOOK.md`
