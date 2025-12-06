import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String title;
  final String body;
  final DateTime timestamp;

  AppNotification({required this.title, required this.body, required this.timestamp});
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

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

  // Show a simple notification and save to Firestore
  static Future<void> showNotification({required int id, required String title, required String body, String? userId}) async {
    // 1. Show Local Notification
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('appointment_channel', 'Appointments', channelDescription: 'Notifications for appointment updates', importance: Importance.max, priority: Priority.high);

      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(id, title, body, platformChannelSpecifics);
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }

    // 2. Save to Firestore (Independent of local notification success)
    if (userId != null) {
      await saveNotificationToFirestore(userId, title, body);
    }
  }

  // Schedule a notification
  static Future<void> scheduleNotification({required int id, required String title, required String body, required DateTime scheduledTime, String? userId}) async {
    // 1. Schedule Local Notification
    try {
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
      debugPrint('Error scheduling local notification: $e');
    }

    // 2. Save to Firestore
    // Note: This saves the notification to history IMMEDIATELY when scheduled.
    // If you want it to appear only when sent, this logic needs to be server-side or handled differently.
    // For now, we save it as a "Pending" or "Scheduled" reminder log.
    if (userId != null) {
      // Modify body to indicate it's a reminder? Or keep as is.
      // Saving it now ensures persistence.
      await saveNotificationToFirestore(userId, title, body, scheduledTime: scheduledTime);
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  static Future<void> requestPermissions() async {
    await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static Future<void> saveNotificationToFirestore(String userId, String title, String body, {DateTime? scheduledTime}) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('notifications').add({
        'title': title,
        'body': body,
        'timestamp': scheduledTime != null ? Timestamp.fromDate(scheduledTime) : FieldValue.serverTimestamp(),
        'read': false,
      });
    } catch (e) {
      debugPrint('Error saving notification to Firestore: $e');
    }
  }

  // Stream of notifications from Firestore
  static Stream<QuerySnapshot> getNotificationsStream(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).collection('notifications').orderBy('timestamp', descending: true).snapshots();
  }
}
