import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const String weighInTimeKey = 'weighInTime';
  static const String weighInDayKey = 'weighInDay';
  static const String bodyweightUpdateDialogShownKey =
      'bodyweightUpdateDialogShown';
  static const String bodyweightUpdateDialogLastShownDateKey =
      'bodyweightUpdateDialogLastShownDate';
  static const String latestNewBodyweight = 'latestNewBodyweight';
  static const String lastSnoozedBodyweightUpdateDateKey =
      'lastSnoozedBodyweightUpdateDate';
  static const String lastWeightUpdateDateKey = 'lastWeightUpdateDate';
  static const String snoozeDurationDaysKey = 'snoozeDurationDays';

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
        await prefs.remove(lastWeightUpdateDateKey);
      }
    }

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
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(weighInTimeKey);
    prefs.remove(weighInDayKey);
    prefs.remove(bodyweightUpdateDialogShownKey);
  }
}
