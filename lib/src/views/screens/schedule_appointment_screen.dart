import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/screens/main_layout_screen.dart';
import 'package:appointment_booking_app/services/notification_service.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> doctorData;
  final Map<String, dynamic> patientData;

  const ScheduleAppointmentScreen({
    super.key,
    required this.doctorData,
    required this.patientData,
  });

  @override
  State<ScheduleAppointmentScreen> createState() =>
      _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTimeSlot;

  final List<String> _timeSlots = [
    '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM', '02:00 PM', '02:30 PM',
    '03:00 PM', '03:30 PM', '04:00 PM', '04:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.madiBlue.withAlpha(57),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.madiGrey,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schedule Appointment',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24.0),

              _buildCalendar(),
              const SizedBox(height: 24.0),

              Text(
                'Select Time',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.madiBlue,
                ),
              ),
              const SizedBox(height: 16.0),
              _buildTimeSlotGrid(),
              const SizedBox(height: 60.0),

              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedDay == null || _selectedTimeSlot == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a date and time slot'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // --- MODIFICATION HERE (1st Request) ---
                    // Add to notification service
                    final String doctorName = widget.doctorData['name'];
                    final String date = _selectedDay.toString().split(' ')[0];
                    NotificationService.addNotification(
                      'Appointment Confirmed!',
                      'Your appointment with $doctorName on $date at $_selectedTimeSlot is confirmed.',
                    );

                    _showConfirmationDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.madiBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Confirm Appointment',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.madiLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 60)),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _selectedTimeSlot = null;
          });
        },
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: AppColors.madiBlue,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.madiBlue.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlotGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemCount: _timeSlots.length,
      itemBuilder: (context, index) {
        final slot = _timeSlots[index];
        final isSelected = _selectedTimeSlot == slot;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTimeSlot = slot;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.madiBlue : AppColors.madiLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Text(
                slot,
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Booking Successful!',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
              color: AppColors.madiBlue,
            ),
          ),
          content: Text(
            'Your appointment with ${widget.doctorData['name']} on ${_selectedDay.toString().split(' ')[0]} at $_selectedTimeSlot has been confirmed.',
            style: TextStyle(fontFamily: 'Ubuntu'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // --- MODIFICATION: Navigate to the MainLayoutScreen's Schedule Tab (index 1) ---
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const MainLayoutScreen(initialIndex: 1),
                  ),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text(
                'Done',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: AppColors.madiBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}