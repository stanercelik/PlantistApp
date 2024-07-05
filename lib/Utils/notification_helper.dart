import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notifications.initialize(initializationSettings);

    await _createNotificationChannel();
    await _createInstantNotificationChannel();

    await _requestNotificationPermission();
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'todo_reminder_channel',
      'TODO Reminders',
      description: 'This channel is used for TODO reminders.',
      importance: Importance.high,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _createInstantNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'instant_reminder_channel',
      'Instant Reminders',
      description: 'This channel is used for instant reminders.',
      importance: Importance.high,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> sendInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      await _notificationDetailsForInstant(),
    );
  }

  static Future<NotificationDetails> _notificationDetailsForInstant() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_reminder_channel',
        'Instant Reminders',
        channelDescription: 'This channel is used for instant reminders.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'todo_reminder_channel',
        'TODO Reminders',
        channelDescription: 'This channel is used for TODO reminders.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledTZDateTime =
        tz.TZDateTime.from(scheduledDateTime, tz.local);

    debugPrint('Current time: ${DateTime.now().toIso8601String()}');
    debugPrint('Current TZ time: $now');
    debugPrint('Scheduled time: ${scheduledDateTime.toIso8601String()}');
    debugPrint('Scheduling notification for: $scheduledTZDateTime');

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledTZDateTime,
        await _notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
      debugPrint('Notification scheduled successfully');
    } catch (error) {
      debugPrint('Error scheduling notification: $error');
    }
  }

  static Future<void> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.notification.request();
    }

    if (!status.isGranted) {
      debugPrint('Notification permission not granted');
    } else {
      debugPrint('Notification permission granted');
    }
  }

  static Future<void> unScheduleNotification(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> unScheduleAllNotifications() async {
    await _notifications.cancelAll();
  }
}
