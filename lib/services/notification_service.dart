import 'package:flutter/foundation.dart';

class AppNotification {
  final String title;
  final String body;
  final DateTime timestamp;

  AppNotification({
    required this.title,
    required this.body,
    required this.timestamp,
  });
}

class NotificationService {
  static final ValueNotifier<List<AppNotification>> notifications =
  ValueNotifier<List<AppNotification>>([]);

  // Private constructor
  NotificationService._();

  // Add a new notification and notify listeners
  static void addNotification(String title, String body) {
    final newNotification = AppNotification(
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );

    // Add to the beginning of the list
    notifications.value = [newNotification, ...notifications.value];

    // TODO: Add logic here to schedule device-level notifications
    // using a package like flutter_local_notifications.
    // e.g., scheduleNotification(newNotification.title, newNotification.body);
    // e.g., scheduleNotification(
    //   "Appointment Reminder",
    //   "Your appointment is in 30 minutes",
    //   scheduledTime: appointmentTime.subtract(Duration(minutes: 30))
    // );
  }
}