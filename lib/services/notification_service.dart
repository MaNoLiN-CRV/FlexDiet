import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String weighInTimeKey = 'weighInTime';
  static const String weighInDayKey = 'weighInDay';
  static const String bodyweightUpdateDialogShownKey =
      'bodyweightUpdateDialogShown';
  static const String latestNewBodyweight = 'latestNewBodyweight';

  Future<void> initialize(
      {required DidReceiveNotificationResponseCallback?
          onDidReceiveNotificationResponse}) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          onDidReceiveNotificationResponse, // Use the callback
    );
  }

  Future<void> scheduleMinuteWeighInNotification({
    required int minute,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'minute_weigh_in', // Channel ID
      'Minute Weigh-in Reminders', // Channel name
      channelDescription: 'Reminders to weigh yourself every minute.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID (unique)
      '¡Es hora de pesarse!', // Notification title
      'Recuerda registrar tu peso para seguir tu progreso.', // Notification body
      _nextInstanceOfMinute(minute),
      NotificationDetails(
        android: androidNotificationDetails,
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'weight_update', // Add a payload to the notification
    );
  }

  tz.TZDateTime _nextInstanceOfMinute(int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      now.hour,
      minute,
    );

    if (scheduledDate.isBefore(now) || scheduledDate == now) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 1));
    }

    return scheduledDate;
  }

  // Function to cancel the notification
  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin
        .cancel(0); // Cancel notification with ID 0
    // Optionally, clear saved preferences (if you want to disable completely)
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(weighInTimeKey);
    prefs.remove(weighInDayKey);
    prefs.remove(bodyweightUpdateDialogShownKey);
  }

  Future<void> requestPermissions() async {
    if (flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>() !=
        null) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
    // Request POST_NOTIFICATIONS permission for Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // Function to request SCHEDULE_EXACT_ALARM permission
  Future<void> requestExactAlarmPermission() async {
    var status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied) {
      status = await Permission.scheduleExactAlarm.request();
      if (status.isGranted) {
        // Permission granted, schedule notification
      } else {
        // Permission denied, handle accordingly (e.g., show a message)
        print('SCHEDULE_EXACT_ALARM permission denied');
      }
    } else if (status.isGranted) {
      // Permission already granted, schedule notification
    }
  }

  // Helper function to load saved notification preferences
  Future<void> loadSavedNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final timeString = prefs.getString(weighInTimeKey);
    final weekday = prefs.getInt(weighInDayKey);

    if (timeString != null && weekday != null) {
      // Parse the time string
      final format = DateFormat("HH:mm");
      DateTime time;
      try {
        time = format.parse(timeString);
      } catch (e) {
        print('Error parsing time string: $e');
        // Clear invalid preferences
        await prefs.remove(weighInTimeKey);
        await prefs.remove(weighInDayKey);
        return; // Stop execution if parsing fails
      }

      // Schedule the notification using the parsed time
      final timeOfDay = TimeOfDay(hour: time.hour, minute: time.minute);
      //await scheduleWeeklyWeighInNotification(
      //    time: timeOfDay, weekday: weekday);
    }
  }

  // Function to check if the bodyweight update dialog has been shown today
  Future<bool> hasBodyweightUpdateDialogBeenShownToday() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(bodyweightUpdateDialogShownKey) ?? false;
  }

  // Function to set the value in bodyweightUpdateDialogShownKey from preferences
  Future<void> setBodyweightUpdateDialogShownToday(bool shown) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(bodyweightUpdateDialogShownKey, shown);
  }

  // Function to get the latest new bodyweight value from preferences
  Future<double?> getLatestBodyweight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(latestNewBodyweight);
  }

  // Function to set the latest new bodyweight value from preferences
  Future<void> setLatestBodyweight(double? weight) async {
    final prefs = await SharedPreferences.getInstance();
    if (weight == null) {
      await prefs.remove(latestNewBodyweight);
    } else {
      await prefs.setDouble(latestNewBodyweight, weight);
    }
  }
}
