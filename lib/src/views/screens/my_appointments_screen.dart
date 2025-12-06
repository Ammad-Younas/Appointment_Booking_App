import 'package:flutter/material.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';

import 'package:appointment_booking_app/src/views/screens/notifications_screen.dart';
import 'package:appointment_booking_app/services/appointment_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appointment_booking_app/src/views/screens/schedule_appointment_screen.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  String _selectedTab = 'upcoming';
  int? _selectedAppointmentIndex;
  String? _selectedAppointmentId; // Added to track selected doc ID

  final AppointmentService _appointmentService = AppointmentService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final bool isUpcoming = _selectedTab == 'upcoming';

    if (_currentUser == null) {
      return const Center(child: Text('Please log in to view appointments.'));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),

              // Header
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
                        'How are you today?',
                        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14.0, color: Colors.grey[400], fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  // Notification Bell
                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle),
                    child: IconButton(
                      icon: Icon(Icons.notifications_outlined, color: Theme.of(context).iconTheme.color, size: 28),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationsScreen()));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),

              // --- Toggle Buttons ---
              _buildToggleButtons(),
              const SizedBox(height: 30.0),

              // --- Appointments List ---
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _appointmentService.getAppointments(_currentUser.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No appointments found.'));
                    }

                    final allAppointments = snapshot.data!.docs;
                    final filteredAppointments = allAppointments.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final status = data['status'] ?? 'Upcoming';
                      if (isUpcoming) {
                        return status == 'Upcoming' || status == 'Rescheduled';
                      } else {
                        return status == 'Completed' || status == 'Cancelled';
                      }
                    }).toList();

                    if (filteredAppointments.isEmpty) {
                      return Center(
                        child: Text(isUpcoming ? 'No upcoming appointments.' : 'No past appointments.', style: TextStyle(color: AppColors.madiGrey)),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredAppointments.length,
                      itemBuilder: (context, index) {
                        final doc = filteredAppointments[index];
                        final appt = doc.data() as Map<String, dynamic>;
                        return _buildAppointmentCard(appt: appt, docId: doc.id, index: index, isSelected: isUpcoming && _selectedAppointmentIndex == index);
                      },
                    );
                  },
                ),
              ),

              // --- Reschedule/Cancel Buttons (if Upcoming) or Delete (if Past) ---
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    final bool isUpcoming = _selectedTab == 'upcoming';

    return Row(
      children: [
        Expanded(
          child: _buildTabButton('Upcoming', isUpcoming, () {
            setState(() {
              _selectedTab = 'upcoming';
              _selectedAppointmentIndex = null;
              _selectedAppointmentId = null;
            });
          }),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: _buildTabButton('Completed', !isUpcoming, () {
            setState(() {
              _selectedTab = 'completed';
              _selectedAppointmentIndex = null;
              _selectedAppointmentId = null;
            });
          }),
        ),
      ],
    );
  }

  Widget _buildTabButton(String text, bool isSelected, VoidCallback onPressed) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.madiBlue : Theme.of(context).cardColor,
          foregroundColor: isSelected ? Colors.white : AppColors.madiGrey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard({required Map<String, dynamic> appt, required String docId, required int index, required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        if (_selectedTab == 'upcoming') {
          setState(() {
            if (_selectedAppointmentIndex == index) {
              _selectedAppointmentIndex = null;
              _selectedAppointmentId = null;
            } else {
              _selectedAppointmentIndex = index;
              _selectedAppointmentId = docId;
            }
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected ? Border.all(color: AppColors.madiBlue, width: 2.0) : null,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, 5))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                width: 70,
                height: 70,
                color: Colors.grey[200],
                child: appt['doctorImage'] != null
                    ? Image.network(
                        appt['doctorImage'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 40, color: Colors.grey),
                      )
                    : FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance.collection('doctors').where('name', isEqualTo: appt['doctorName']).limit(1).get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator(strokeWidth: 2));
                          }
                          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                            final doctorData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                            final imageUrl = doctorData['image'] ?? doctorData['imageUrl']; // Support both keys
                            if (imageUrl != null && imageUrl.isNotEmpty) {
                              return Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 40, color: Colors.grey),
                              );
                            }
                          }
                          return Icon(Icons.person, size: 40, color: Colors.grey);
                        },
                      ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appt['doctorName'] ?? 'Doctor',
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${(appt['date'] as Timestamp).toDate().toString().split(' ')[0]} at ${appt['timeSlot']}',
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14.0, color: AppColors.madiGrey),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    appt['status'] ?? '',
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14.0, color: appt['status'] == 'Cancelled' ? Colors.red : AppColors.madiBlue, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final bool isAppointmentSelected = _selectedAppointmentIndex != null;
    final bool isUpcoming = _selectedTab == 'upcoming';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        children: [
          if (isUpcoming) ...[
            Expanded(
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: isAppointmentSelected
                      ? () async {
                          if (_selectedAppointmentId == null) return;

                          // Show loading
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(child: CircularProgressIndicator()),
                          );

                          try {
                            final docSnapshot = await FirebaseFirestore.instance.collection('appointments').doc(_selectedAppointmentId).get();

                            if (!docSnapshot.exists) {
                              if (context.mounted) Navigator.pop(context);
                              return;
                            }

                            final appointment = docSnapshot.data() as Map<String, dynamic>;
                            final String doctorName = appointment['doctorName'] ?? 'Doctor';

                            // Fetch doctor details by name
                            final doctorQuery = await FirebaseFirestore.instance.collection('doctors').where('name', isEqualTo: doctorName).limit(1).get();

                            Map<String, dynamic> doctorData;
                            if (doctorQuery.docs.isNotEmpty) {
                              doctorData = doctorQuery.docs.first.data();
                              doctorData['id'] = doctorQuery.docs.first.id;
                            } else {
                              // Fallback
                              doctorData = {'name': doctorName, 'image': 'https://randomuser.me/api/portraits/men/32.jpg', 'qualification': 'Specialist', 'location': 'Hospital'};
                            }

                            final patientData = {'name': appointment['patientName'] ?? 'User'};

                            if (!context.mounted) return;
                            Navigator.pop(context); // Close loading

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScheduleAppointmentScreen(doctorData: doctorData, patientData: patientData, appointmentId: _selectedAppointmentId),
                              ),
                            );
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                            }
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).cardColor,
                    foregroundColor: isAppointmentSelected ? AppColors.madiBlue : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: isAppointmentSelected ? AppColors.madiBlue : Colors.grey, width: 2.0),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: Theme.of(context).cardColor.withValues(alpha: 0.5),
                  ),
                  child: Text(
                    'Reschedule',
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: isAppointmentSelected
                      ? () {
                          _showCancelConfirmationDialog();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAppointmentSelected ? AppColors.madiBlue : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: isAppointmentSelected
                      ? () {
                          _showDeleteConfirmationDialog();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAppointmentSelected ? Colors.red : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(
                    'Delete',
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(
            'Cancel Appointment?',
            style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Text(
            'Are you sure you want to cancel this appointment?',
            style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: AppColors.madiGrey),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_selectedAppointmentId != null) {
                  await _appointmentService.cancelAppointment(_selectedAppointmentId!);

                  if (!context.mounted) return;

                  setState(() {
                    _selectedAppointmentIndex = null;
                    _selectedAppointmentId = null;
                  });

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appointment cancelled successfully.')));
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Yes, Cancel',
                style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(
            'Delete Appointment?',
            style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: Text(
            'Are you sure you want to delete this appointment history?',
            style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: AppColors.madiGrey),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_selectedAppointmentId != null) {
                  await _appointmentService.deleteAppointment(_selectedAppointmentId!);

                  if (!context.mounted) return;

                  setState(() {
                    _selectedAppointmentIndex = null;
                    _selectedAppointmentId = null;
                  });

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appointment deleted successfully.')));
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Yes, Delete',
                style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
