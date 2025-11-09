import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/services/notification_service.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        // --- MODIFICATION: AppBar REMOVED ---
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                // --- MODIFICATION: Added consistent header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    // You can add a "Clear All" button here if you want
                    TextButton(
                      onPressed: () {
                        // Optional: Clear notifications
                        // NotificationService.notifications.value = [];
                      },
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          color: AppColors.madiGrey,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30.0),

                // --- List of Notifications ---
                Expanded(
                  child: ValueListenableBuilder<List<AppNotification>>(
                    valueListenable: NotificationService.notifications,
                    builder: (context, notificationList, child) {
                      if (notificationList.isEmpty) {
                        return Center(
                          child: Text(
                            'No notifications yet.',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 16.0,
                              color: AppColors.madiGrey,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: notificationList.length,
                        itemBuilder: (context, index) {
                          final notification = notificationList[index];
                          return _buildNotificationCard(notification);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.madiLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.madiBlue.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_active,
              color: AppColors.madiBlue,
              size: 28,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  notification.body,
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 14.0,
                    color: AppColors.madiGrey,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  DateFormat('MMM d, h:mm a').format(notification.timestamp),
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 12.0,
                    color: AppColors.madiGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}