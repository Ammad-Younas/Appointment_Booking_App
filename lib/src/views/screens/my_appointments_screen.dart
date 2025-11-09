import 'package:flutter/material.dart' hide BoxShadow;
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/screens/schedule_appointment_screen.dart';
import 'package:appointment_booking_app/src/views/screens/notifications_screen.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  String _selectedTab = 'upcoming';
  int? _selectedAppointmentIndex;

  List<Map<String, dynamic>> _upcomingAppointments = [
    {
      'name': 'Dr. Assad Abbas',
      'specialty': 'Nerologist',
      'time': '10:00 AM',
      'image': 'assets/images/doctor_1.png',
      'rating': 4.5, 'price': 28, 'slots': 5,
    },
    {
      'name': 'Dr. Kamran',
      'specialty': 'Dentist',
      'time': '11:30 AM',
      'image': 'assets/images/doctor_2.png',
      'rating': 4.3, 'price': 25, 'slots': 5,
    },
  ];

  final List<Map<String, dynamic>> _completedAppointments = [
    {
      'name': 'Dr. Assad Abbas',
      'specialty': 'Nerologist',
      'time': '10:00 AM',
      'image': 'assets/images/doctor_1.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isUpcoming = _selectedTab == 'upcoming';

    // --- MODIFICATION: Removed Scaffold and AnnotateRegion ---
    // This is now just the content of a tab
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),

              // Header from home_screen.dart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: 'Hello, ',
                              style: TextStyle(color: Colors.black),
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
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 14.0,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  // Notification Bell
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                        size: 28,
                      ),
                      // --- MODIFICATION HERE (1st Request) ---
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
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
                child: ListView.builder(
                  itemCount: (isUpcoming ? _upcomingAppointments.length : _completedAppointments.length),
                  itemBuilder: (context, index) {
                    final appt = isUpcoming ? _upcomingAppointments[index] : _completedAppointments[index];
                    return _buildAppointmentCard(
                      appt: appt,
                      index: index,
                      isSelected: isUpcoming && _selectedAppointmentIndex == index,
                    );
                  },
                ),
              ),

              // --- Reschedule/Cancel Buttons (if Upcoming) ---
              if (isUpcoming) _buildActionButtons(),
            ],
          ),
        ),
      ),
      // --- MODIFICATION: Removed the bottomNavigationBar ---
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
            });
          }),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: _buildTabButton('Completed', !isUpcoming, () {
            setState(() {
              _selectedTab = 'completed';
              _selectedAppointmentIndex = null;
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
          backgroundColor: isSelected ? AppColors.madiBlue : Color(0xFFE0E0E0),
          foregroundColor: isSelected ? Colors.white : AppColors.madiGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard({
    required Map<String, dynamic> appt,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        if (_selectedTab == 'upcoming') {
          setState(() {
            if (_selectedAppointmentIndex == index) {
              _selectedAppointmentIndex = null;
            } else {
              _selectedAppointmentIndex = index;
            }
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.madiLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected
              ? Border.all(color: AppColors.madiBlue, width: 2.0)
              : null,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                width: 70,
                height: 70,
                color: Colors.grey[200],
                child: Image.asset(
                  appt['image'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appt['name'],
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  appt['specialty'],
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 14.0,
                    color: AppColors.madiGrey,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  appt['time'],
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 14.0,
                    color: AppColors.madiGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final bool isAppointmentSelected = _selectedAppointmentIndex != null;
    Map<String, dynamic>? selectedAppointment;
    if (isAppointmentSelected) {
      selectedAppointment = _upcomingAppointments[_selectedAppointmentIndex!];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: isAppointmentSelected ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ScheduleAppointmentScreen(
                        doctorData: selectedAppointment!,
                        patientData: { 'name': 'Appointly User' },
                      ),
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: isAppointmentSelected ? AppColors.madiBlue : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                        color: isAppointmentSelected ? AppColors.madiBlue : Colors.grey,
                        width: 2.0
                    ),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.white,
                ),
                child: Text(
                  'Reschedule',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: isAppointmentSelected ? () {
                  _showCancelConfirmationDialog();
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAppointmentSelected ? AppColors.madiBlue : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Cancel Appointment?',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to cancel this appointment?',
            style: TextStyle(fontFamily: 'Ubuntu'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: AppColors.madiGrey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _upcomingAppointments.removeAt(_selectedAppointmentIndex!);
                  _selectedAppointmentIndex = null;
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Yes, Cancel',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}