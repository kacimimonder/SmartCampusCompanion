import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Lightweight NotificationService wrapper used to schedule local reminders
/// and handle notification taps to deep-link into the app.
class NotificationService {
  NotificationService._(this._plugin, this.navigatorKey);

  static final NotificationService _instance = NotificationService._(
    FlutterLocalNotificationsPlugin(),
    null,
  );

  factory NotificationService({GlobalKey<NavigatorState>? navigatorKey}) {
    if (navigatorKey != null) {
      _instance.navigatorKey = navigatorKey;
    }
    return _instance;
  }

  final FlutterLocalNotificationsPlugin _plugin;
  GlobalKey<NavigatorState>? navigatorKey;

  Future<void> init() async {
    if (kIsWeb) {
      return;
    }

    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();

    final settings = InitializationSettings(android: android, iOS: iOS);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) async {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          _handlePayload(payload);
        }
      },
    );
  }

  Future<void> scheduleReminder({
    required int id,
    required DateTime scheduledDate,
    required String title,
    required String body,
    String? route,
    Map<String, dynamic>? extra,
  }) async {
    if (kIsWeb) {
      if (kDebugMode) {
        print('Local notifications are disabled on web.');
      }
      return;
    }

    final payload = jsonEncode({'route': route ?? '/', 'extra': extra ?? {}});

    final androidDetails = AndroidNotificationDetails(
      'smartcampus_reminders',
      'Reminders',
      channelDescription: 'Class and event reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    final iOSDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate.toUtc(), tz.UTC),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  void _handlePayload(String payload) {
    try {
      final map = jsonDecode(payload) as Map<String, dynamic>;
      final route = map['route'] as String? ?? '/';

      // Use navigatorKey to perform routing when possible.
      if (navigatorKey?.currentState != null) {
        navigatorKey!.currentState!.pushNamed(route);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to handle notification payload: $e');
      }
    }
  }
}
