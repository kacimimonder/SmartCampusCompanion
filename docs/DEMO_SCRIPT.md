# Demo Script — SmartCampus Companion

Duration: 3–5 minutes recording

1. Start (10s) — Title card: "SmartCampus Companion — Demo" and quick verbal intro: scope and platform (Android / web preview).

2. Launch & Home (20s) — Open app, show Home / Dashboard with cached data loaded. Explain offline-first behavior briefly.

3. Announcements & Events (30s) — Pull-to-refresh the announcements list to demonstrate forced refresh. Show cached fallback when offline (toggle airplane mode on device/emulator).

4. Notifications (30s) — Schedule a demo reminder using Settings -> "Schedule demo reminder". Show that a notification is scheduled (explain timezone-aware scheduling). Tap the notification to deep-link into an announcement or the dashboard.

5. Biometric Demo (30s) — Open Settings, trigger Biometric unlock demo; demonstrate biometric prompt and unlocked token state.

6. Device Features (30s) — Show location/sensors/camera demo screen (if possible on device). Explain platform fallbacks for web.

7. Tests & Code (30s) — Show the `test/` folder and run `flutter test` in terminal; show passing unit tests.

8. Wrap-up (10s) — Mention where to find source, release artifacts, and the full technical report in `docs/`.

Recording tips:

- Use a physical device when possible for camera and biometric demo.
- Record with microphone; narrate each step concisely.
- Capture full-screen emulator/device with 30–60 fps for clarity.
