# SmartCampus Companion - Agent Execution Playbook

## 1. Why This Document Exists

`PROJECT_SPEC_AND_IMPLEMENTATION_PLAN.md` is a strong requirement and architecture document.
This playbook is an execution-focused companion for implementation sessions so work can be done quickly, consistently, and with lower rework.

Use this file as the primary operational guide for Week 5 to Week 8 delivery.

## 2. Current Baseline (Verified)

Completed:

- Week 1 navigation skeleton
- Week 2 networking core
- Week 3 offline persistence and secure/basic settings storage
- Week 4 permissions and device integrations

Pending:

- Week 5 notifications + background workflow
- Week 6 biometric/auth hardening + performance profiling
- Week 7 tests + stabilization
- Week 8 delivery packaging

## 3. Non-Goals During Feature Sessions

- Do not redesign architecture unless blocked.
- Do not introduce package churn without milestone need.
- Do not mix unrelated fixes into milestone commits.
- Do not change public behavior without updating docs and test coverage.

## 4. Delivery Protocol Per Session

1. Read this playbook and the project spec.
2. Confirm milestone target (for example: Week 5 notifications).
3. Implement only that milestone scope.
4. Run static checks and tests.
5. Update docs (implemented scope and OS concept mapping).
6. Commit with milestone-specific message.

## 5. Milestone Backlog With Definition of Done

## 5.1 Week 5 - Notifications and Background Execution

Implementation tasks:

- Add `flutter_local_notifications` and initialize at app startup.
- Define notification channel (Android) and permission request flow (iOS where applicable).
- Schedule at least one local reminder (for a timetable item or demo class).
- Add tap payload deep linking to route user to target screen.
- Add periodic refresh strategy for announcements metadata.

Suggested files to touch:

- `pubspec.yaml`
- `lib/main.dart`
- `lib/presentation/app_router.dart`
- `lib/presentation/screens/*` (where reminder setup is triggered)
- `lib/core/services/notification_service.dart` (new)
- `lib/core/services/background_refresh_service.dart` (new if needed)

Definition of done:

- Local notification can be scheduled from UI or startup workflow.
- Tapping notification navigates to expected route.
- At least one periodic refresh path is implemented/documented and executable.
- `flutter analyze` passes.

## 5.2 Week 6 - Security Hardening and Biometrics

Implementation tasks:

- Add `local_auth` package.
- Implement biometric unlock gate after initial authenticated session exists.
- Add simple session expiration/invalidation policy.
- Ensure secure token remains only in secure storage.

Suggested files to touch:

- `pubspec.yaml`
- `lib/data/repositories/settings_repository.dart` or new auth repository
- `lib/presentation/viewmodels/settings_view_model.dart` or auth view model
- `lib/presentation/screens/*` for unlock flow
- `lib/main.dart` for startup gate logic

Definition of done:

- App prompts biometric auth when reopening with active session.
- Logout clears session token and bypasses biometric gate next startup.
- Failure and denial flows produce clear user messages.
- `flutter analyze` passes.

## 5.3 Week 6 - Performance Profiling Evidence

Implementation tasks:

- Capture baseline (rebuild behavior and frame stability) using DevTools.
- Apply 2 targeted optimizations.
- Capture after metrics/screenshots.
- Document before/after results.

Definition of done:

- Two optimizations implemented and measurable.
- Evidence added to docs report section.
- No regressions in core user flows.

## 5.4 Week 7 - Testing and Stabilization

Implementation tasks:

- Add repository unit tests for online/offline/cache fallback branches.
- Add parsing/model tests for expected and malformed payloads.
- Add tests for settings persistence behavior where practical.

Definition of done:

- Tests run reliably in CI/local.
- Critical paths covered: fetch success, fetch failure fallback, offline no-cache error.
- Known bugs list is empty or explicitly documented.

## 5.5 Week 8 - Final Delivery

Implementation tasks:

- Finalize technical report assets and architecture diagrams.
- Prepare short demo script and capture walkthrough.
- Ensure repository history remains milestone-readable.

Definition of done:

- Deliverables ready: source code, report, demo video, presentation.
- README/docs include run instructions and milestone completion status.

## 6. Commit Strategy

Use one commit per milestone concern.

Preferred message format:

- `feat: implement week5 local notifications and deep link routing`
- `feat: add week5 background refresh workflow`
- `feat: implement week6 biometric unlock and session hardening`
- `perf: optimize rebuild scope and list rendering`
- `test: add repository offline-first and parsing tests`
- `docs: finalize technical report mappings and profiling evidence`

## 7. Session Exit Checklist

Before ending a coding session, ensure:

- Scope stayed within milestone.
- `flutter analyze` passes.
- Relevant tests pass (when present).
- Docs updated for implemented behavior.
- Commit created with milestone-focused message.

## 8. Risk Watchlist

- Notification behavior differs between Android and iOS; validate both paths.
- Background execution capabilities are platform-constrained in Flutter; keep expectations realistic and document tradeoffs.
- Biometric availability varies by device; include graceful fallback.
- Offline cache schema changes can break existing local data; version DB migrations carefully.

## 9. Source of Truth Priority

When docs conflict, prioritize in this order:

1. Assignment specification (course requirements)
2. `PROJECT_SPEC_AND_IMPLEMENTATION_PLAN.md`
3. This execution playbook
4. Inline code comments

This ensures grading requirements remain the final authority.
