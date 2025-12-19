import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/screens/notifications_screen.dart';

class DoctorAppointmentsTab extends StatelessWidget {
  const DoctorAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('User not logged in'));
    }
    final String doctorId = user.uid;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30.0), // Changed from 20 to 30 for more spacing "Down"
            // --- Header Section matching Patient Home ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 24.0, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: 'Hello, ',
                            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                          TextSpan(
                            text: 'Appointly 👋',
                            style: TextStyle(color: AppColors.madiBlue),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Doctor Dashboard',
                      style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14.0, color: Colors.grey[400], fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                // --- Notification Bell (Added) ---
                // --- Notification Bell Removed as per request ---
              ],
            ),
            const SizedBox(height: 30.0),
            Text(
              'Upcoming Appointments',
              style: TextStyle(fontFamily: 'Ubuntu', fontSize: 22.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('appointments').where('doctorId', isEqualTo: doctorId).orderBy('date', descending: false).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading appointments: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No upcoming appointments.',
                        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, color: AppColors.madiGrey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      DateTime date = (data['date'] as Timestamp).toDate();
                      String time = data['timeSlot'] ?? '00:00 AM'; // FIXED: Changed 'time' to 'timeSlot' to match Firestore
                      String patientName = data['patientName'] ?? 'Unknown Patient';
                      String status = data['status'] ?? 'Upcoming';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5))],
                          border: Border.all(color: AppColors.madiBlue.withOpacity(0.1)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(color: AppColors.madiBlue.withOpacity(0.1), shape: BoxShape.circle),
                              child: Text(
                                DateFormat('d\nMMM').format(date),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patientName,
                                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '$time - $status',
                                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14.0, color: AppColors.madiGrey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
