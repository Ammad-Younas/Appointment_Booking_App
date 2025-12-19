import 'package:flutter/material.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(fontFamily: 'Ubuntu', fontSize: 24.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0), // Spacing below AppBar
              // --- List of Notifications ---
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: NotificationService.getNotificationsStream(FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Error loading notifications:\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'No notifications yet.',
                          style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, color: AppColors.madiGrey),
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    // Filter out future notifications
                    final now = DateTime.now();
                    final pastNotifications = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final Timestamp? timestamp = data['timestamp'] as Timestamp?;
                      if (timestamp == null) return true; // Show if no timestamp
                      return timestamp.toDate().isBefore(now);
                    }).toList();

                    if (pastNotifications.isEmpty) {
                      return Center(
                        child: Text(
                          'No notifications yet.',
                          style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, color: AppColors.madiGrey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: pastNotifications.length,
                      itemBuilder: (context, index) {
                        final data = pastNotifications[index].data() as Map<String, dynamic>;
                        final Timestamp? timestamp = data['timestamp'] as Timestamp?;

                        final notification = AppNotification(title: data['title'] ?? 'Notification', body: data['body'] ?? '', timestamp: timestamp?.toDate() ?? DateTime.now());

                        return _buildNotificationCard(context, notification);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, AppNotification notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(color: AppColors.madiBlue.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(Icons.notifications_active, color: AppColors.madiBlue, size: 28),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
                ),
                const SizedBox(height: 4.0),
                Text(
                  notification.body,
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14.0, color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.madiGrey),
                ),
                const SizedBox(height: 8.0),
                Text(
                  DateFormat('MMM d, h:mm a').format(notification.timestamp),
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 12.0, color: AppColors.madiGrey, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
