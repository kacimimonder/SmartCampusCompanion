# SmartCampus Companion - Overview and Technical Deep Dive

## 1. Project Overview
SmartCampus Companion is a mobile app for students to quickly access campus announcements, events, and timetable-related tasks.

This implementation covers Week 1 and Week 2 milestones:
- Week 1: Project initiation, UI skeleton, and route/navigation setup.
- Week 2: Core logic with domain models and REST API integration.

### Current User Flows (Week 1-2)
1. User opens the app and lands on the Dashboard.
2. App fetches campus-related content from REST endpoints.
3. User navigates between Home, Announcements, Events, and Settings.
4. User can pull-to-refresh or press the refresh icon to reload data.

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
- Basic loading and error UI states.
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
- `DashboardScreen`, `AnnouncementsScreen`, `EventsScreen`, `SettingsScreen`.
- `DashboardViewModel`: Loads and stores app-facing state.
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

### 3.3 Data Layer
Files under `lib/data/` and `lib/core/network/`.

Responsibilities:
- Perform REST calls.
- Parse JSON payloads.
- Expose data through repository abstraction.

Key components:
- `ApiClient`: HTTP GET wrapper with timeout and response validation.
- `CampusRemoteDataSource`: Endpoint-specific data fetching logic.
- `CampusRepository`: Data-access abstraction for the ViewModel.

## 4. Technical In-Depth

### 4.1 App Startup and Dependency Composition
In `lib/main.dart`, dependencies are manually wired in `main()`:
1. `ApiClient` is created.
2. `CampusRemoteDataSource` is created using `ApiClient`.
3. `CampusRepository` is created using the data source.
4. `DashboardViewModel` is created using the repository.
5. `MaterialApp` is launched with a route generator.

This explicit composition is simple and suitable for this stage. In later weeks, this can migrate to a dependency injection package.

### 4.2 Navigation Strategy
Navigation is centralized in `lib/presentation/app_router.dart`:
- Routes:
  - `/`
  - `/announcements`
  - `/events`
  - `/settings`
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

### 4.4 State Management Flow
Current state management uses Flutter's `ChangeNotifier`:
- `DashboardViewModel.loadAllData()` fetches announcements, events, and timetable in parallel with `Future.wait()`.
- State updates:
  - `_isLoading = true` before request.
  - Data lists updated on success.
  - `_errorMessage` set on failure.
  - `notifyListeners()` after each major change.

UI reaction:
- Screens rebuild via `AnimatedBuilder` in `HomeShell`.
- Each screen decides whether to show loading, error, empty, or data list views.

### 4.5 Why JSONPlaceholder Endpoints Were Chosen
For Week 2 networking validation:
- `/posts` -> announcements
- `/albums` -> events
- `/todos` -> timetable items

This gives realistic JSON parsing paths and supports offline-first expansion in Week 3 via caching.

## 5. Mobile OS Concepts Mapped (Week 1-2 only)
Implemented now:
- Networking: REST calls with timeout and failure handling.
- UI + Navigation: multi-screen app structure and route management.

Planned for upcoming weeks:
- Local persistence and offline mode.
- Permissions and device features.
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

## 8. Week 3+ Extension Plan
1. Add local database (offline cache) and repository fallback.
2. Persist settings using `shared_preferences` and secure values via `flutter_secure_storage`.
3. Introduce connectivity awareness and offline banner.
4. Add authentication and session model.
5. Add permissions-based device integrations.
