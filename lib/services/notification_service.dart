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
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('appointment_channel', 'Appointments', channelDescription: 'Notifications for appointment updates', importance: Importance.max, priority: Priority.high);

      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(id, title, body, platformChannelSpecifics);

      if (userId != null) {
        await saveNotificationToFirestore(userId, title, body);
      }
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  // Schedule a notification
  static Future<void> scheduleNotification({required int id, required String title, required String body, required DateTime scheduledTime, String? userId}) async {
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

      // Save to Firestore so user sees it in their history
      if (userId != null) {
        await saveNotificationToFirestore(userId, title, body);
      }
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  static Future<void> requestPermissions() async {
    await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static Future<void> saveNotificationToFirestore(String userId, String title, String body) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('notifications').add({'title': title, 'body': body, 'timestamp': FieldValue.serverTimestamp(), 'read': false});
    } catch (e) {
      debugPrint('Error saving notification to Firestore: $e');
    }
  }

  // Stream of notifications from Firestore
  static Stream<QuerySnapshot> getNotificationsStream(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).collection('notifications').orderBy('timestamp', descending: true).snapshots();
  }
}
