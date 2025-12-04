import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class AppNotification {
  final String title;
  final String body;
  final DateTime timestamp;

  AppNotification({required this.title, required this.body, required this.timestamp});
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // In-memory list for the UI
  static final ValueNotifier<List<AppNotification>> notifications = ValueNotifier<List<AppNotification>>([]);

  // Initialize the notification service
  static Future<void> initialize() async {
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(requestSoundPermission: true, requestBadgePermission: true, requestAlertPermission: true);

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    // Request permissions on Android 13+
    await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  // Show a simple notification and add to local list
  static Future<void> showNotification({required int id, required String title, required String body}) async {
    try {
      // Add to local list
      addNotificationToUI(title, body);

      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('appointment_channel', 'Appointments', channelDescription: 'Notifications for appointment updates', importance: Importance.max, priority: Priority.high);

      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(id, title, body, platformChannelSpecifics);
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  // Schedule a notification
  static Future<void> scheduleNotification({required int id, required String title, required String body, required DateTime scheduledTime}) async {
    try {
      addNotificationToUI(title, body);

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails('appointment_channel', 'Appointments', channelDescription: 'Notifications for appointment updates', importance: Importance.max, priority: Priority.high),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  static Future<void> requestPermissions() async {
    await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static void addNotificationToUI(String title, String body) {
    final newNotification = AppNotification(title: title, body: body, timestamp: DateTime.now());
    notifications.value = [newNotification, ...notifications.value];
  }
}
