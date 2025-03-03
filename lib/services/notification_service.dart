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
  static const String bodyweightUpdateDialogLastShownDateKey =
      'bodyweightUpdateDialogLastShownDate';
  static const String latestNewBodyweight = 'latestNewBodyweight';
  static const String lastSnoozedBodyweightUpdateDateKey =
      'lastSnoozedBodyweightUpdateDate';
  static const String lastWeightUpdateDateKey =
      'lastWeightUpdateDate'; // NEW key
  static const String snoozeDurationDaysKey = 'snoozeDurationDays'; // NEW key

  Future<void> initialize(
      {required DidReceiveNotificationResponseCallback?
          onDidReceiveNotificationResponse}) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_notification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> scheduleWeeklyWeighInNotification({
    required TimeOfDay time,
    required DayOfWeek dayOfWeek,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'weekly_weigh_in', // Channel ID
      'Weekly Weigh-in Reminders', // Channel name
      channelDescription: 'Reminders to weigh yourself weekly.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_notification',
      color: Colors.blue,
      styleInformation: DefaultStyleInformation(true, true),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID (unique)
      '¡Es hora de pesarse!', // Notification title
      'Recuerda registrar tu peso para seguir tu progreso.', // Notification body
      _nextInstanceOfDayAndTime(time, dayOfWeek),
      NotificationDetails(
        android: androidNotificationDetails,
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'weight_update',
    );
  }

  tz.TZDateTime _nextInstanceOfDayAndTime(TimeOfDay time, DayOfWeek dayOfWeek) {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    int dayDifference = dayOfWeek.value - now.weekday;
    if (dayDifference <= 0) {
      dayDifference += 7;
    }

    tz.TZDateTime scheduledDate = now.add(Duration(days: dayDifference));
    scheduledDate = tz.TZDateTime(tz.local, scheduledDate.year,
        scheduledDate.month, scheduledDate.day, time.hour, time.minute);

    return scheduledDate;
  }

  Future<void> requestPermissions() async {
    await Permission.notification.request();
  }

  Future<void> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.status.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> setLatestBodyweight(double? weight) async {
    final prefs = await SharedPreferences.getInstance();
    if (weight != null) {
      await prefs.setDouble(latestNewBodyweight, weight);
    } else {
      await prefs.remove(latestNewBodyweight);
    }
  }

  Future<double?> getLatestBodyweight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(latestNewBodyweight);
  }

  Future<void> setBodyweightUpdateDialogShownToday(bool shown) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(bodyweightUpdateDialogShownKey, shown);
    if (shown) {
      await prefs.setString(bodyweightUpdateDialogLastShownDateKey,
          DateFormat('yyyy-MM-dd').format(DateTime.now()));
    }
  }

  Future<bool> hasBodyweightUpdateDialogBeenShownToday() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShownDate =
        prefs.getString(bodyweightUpdateDialogLastShownDateKey);
    if (lastShownDate == null) return false;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return lastShownDate == today;
  }

  Future<void> snoozeBodyweightUpdateDialog({int days = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: days));
    final futureDateString = DateFormat('yyyy-MM-dd').format(futureDate);

    await prefs.setString(lastSnoozedBodyweightUpdateDateKey,
        futureDateString); // Save future's date
    await prefs.setInt(snoozeDurationDaysKey,
        days); // Store snooze duration so that we can correctly calculate next schedule
  }

  Future<void> setLastWeightUpdateDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastWeightUpdateDateKey,
        DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  Future<bool> shouldShowBodyweightUpdateDialog() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if a weight update has been performed in the last week
    final lastUpdateDateString = prefs.getString(lastWeightUpdateDateKey);
    if (lastUpdateDateString != null) {
      try {
        final lastUpdateDate =
            DateFormat('yyyy-MM-dd').parse(lastUpdateDateString);
        final now = DateTime.now();
        final difference = now.difference(lastUpdateDate).inDays;

        if (difference < 7) {
          // Less than 7 days since last update, don't show the dialog
          return false;
        } else {
          // More than 7 days, clear the update date
          await prefs.remove(lastWeightUpdateDateKey);
        }
      } catch (e) {
        // Handle parsing errors
        print("Error parsing lastWeightUpdateDate: $e");
        await prefs.remove(lastWeightUpdateDateKey);
      }
    }

    // Check if it's already been shown today

    // Check if snoozed and if snooze date is today
    final lastSnoozedDate = prefs.getString(lastSnoozedBodyweightUpdateDateKey);
    if (lastSnoozedDate != null) {
      final today = DateTime.now();
      final parsedSnoozedDate = DateFormat('yyyy-MM-dd').parse(lastSnoozedDate);

      // Get number of days to snooze
      final numberOfDays = prefs.getInt(snoozeDurationDaysKey) ?? 1;

      // Add those number of days to the day the alert was snoozed to see if we should show the modal again
      final shouldShow =
          parsedSnoozedDate.add(Duration(days: numberOfDays)).isBefore(today);
      if (!shouldShow) {
        return false; // Don't show if snoozed to today
      } else {
        // Clear snooze data if past the snooze date
        await prefs.remove(lastSnoozedBodyweightUpdateDateKey);
        await prefs.remove(snoozeDurationDaysKey);
      }
    }

    return true; // Show if not already shown, not snoozed, and not recently updated
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin
        .cancel(0); // Cancel notification with ID 0

    final prefs = await SharedPreferences.getInstance();
    prefs.remove(weighInTimeKey);
    prefs.remove(weighInDayKey);
    prefs.remove(bodyweightUpdateDialogShownKey);
  }
}

// Helper enum to represent days of the week
enum DayOfWeek {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5),
  saturday(6),
  sunday(7);

  const DayOfWeek(this.value);
  final int value;
}
