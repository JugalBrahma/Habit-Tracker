import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_tracker/service/model/user_model.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialize the plugin
    await _notificationsPlugin.initialize(settings: initializationSettings);

    // Request permissions for Android 13+
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();
  }

  static Future<void> updateHabitNotification(List<Habit> habits) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekdayLabel = DateFormat.E().format(today);

    // Get habits scheduled for today
    final scheduledToday = habits
        .where((h) => h.repeatDays.contains(weekdayLabel))
        .toList();

    if (scheduledToday.isEmpty) {
      await _notificationsPlugin.cancel(id: 0);
      return;
    }

    final doneToday = scheduledToday
        .where((h) => h.completedDateSet.contains(today))
        .length;
    final totalToday = scheduledToday.length;

    if (doneToday == totalToday) {
      // All habits done for today, remove notification
      await _notificationsPlugin.cancel(id: 0);
      return;
    }

    // Still habits left to do
    String title = "Daily Progress";
    String body = doneToday == 0
        ? "0/$totalToday habits have been done"
        : "$doneToday/$totalToday habits have been finished today";

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'habit_status_channel',
          'Daily Habit Status',
          channelDescription: 'Shows how many habits you have completed today',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
          onlyAlertOnce: true,
          showWhen: false,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}
