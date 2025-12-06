import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/screens/main_layout_screen.dart';
import 'package:appointment_booking_app/services/notification_service.dart';
import 'package:appointment_booking_app/services/appointment_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> doctorData;
  final Map<String, dynamic> patientData;

  final String? appointmentId;

  const ScheduleAppointmentScreen({super.key, required this.doctorData, required this.patientData, this.appointmentId});

  @override
  State<ScheduleAppointmentScreen> createState() => _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTimeSlot;
  bool _isLoading = false;

  final AppointmentService _appointmentService = AppointmentService();

  final List<String> _timeSlots = ['09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM', '02:00 PM', '02:30 PM', '03:00 PM', '03:30 PM', '04:00 PM', '04:30 PM'];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    bool isRescheduling = widget.appointmentId != null;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                decoration: BoxDecoration(color: AppColors.madiBlue.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: Center(child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).iconTheme.color, size: 18)),
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
                isRescheduling ? 'Reschedule Appointment' : 'Schedule Appointment',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 28.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
              ),
              const SizedBox(height: 24.0),

              _buildCalendar(),
              const SizedBox(height: 24.0),

              Text(
                'Select Time',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
              ),
              const SizedBox(height: 16.0),
              _buildTimeSlotGrid(),
              const SizedBox(height: 60.0),

              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : (isRescheduling ? _rescheduleAppointment : _bookAppointment),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.madiBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isRescheduling ? 'Confirm Reschedule' : 'Confirm Appointment',
                          style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
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
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20.0)),
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
          titleTextStyle: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, fontSize: 18.0, color: Theme.of(context).textTheme.titleLarge?.color),
          leftChevronIcon: Icon(Icons.chevron_left, color: Theme.of(context).iconTheme.color),
          rightChevronIcon: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(color: AppColors.madiBlue, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(color: AppColors.madiBlue.withValues(alpha: 0.5), shape: BoxShape.circle),
          defaultTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          weekendTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
      ),
    );
  }

  Widget _buildTimeSlotGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2.5, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0),
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
              color: isSelected ? AppColors.madiBlue : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.0),
              border: isSelected ? null : Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Center(
              child: Text(
                slot,
                style: TextStyle(fontFamily: 'Ubuntu', color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _bookAppointment() async {
    if (_selectedDay == null || _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a date and time slot'), backgroundColor: Colors.red));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You must be logged in to book an appointment.')));
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final String doctorName = widget.doctorData['name'];
    final String date = _selectedDay.toString().split(' ')[0];

    // Book appointment in Firestore
    final result = await _appointmentService.bookAppointment(
      userId: user.uid,
      doctorId: widget.doctorData['name'], // Using name as ID for now or generate one
      doctorName: doctorName,
      patientName: widget.patientData['name'] ?? 'User',
      doctorImage: widget.doctorData['image'] ?? widget.doctorData['imageUrl'],
      date: _selectedDay!,
      timeSlot: _selectedTimeSlot!,
      status: 'Upcoming',
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      // Parse date and time to get DateTime object
      final timeParts = _selectedTimeSlot!.split(' '); // "09:00" "AM"
      final time = timeParts[0].split(':'); // "09" "00"
      int hour = int.parse(time[0]);
      final int minute = int.parse(time[1]);
      if (timeParts[1] == 'PM' && hour != 12) hour += 12;
      if (timeParts[1] == 'AM' && hour == 12) hour = 0;

      final appointmentTime = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day, hour, minute);

      // Schedule notification 15 minutes before
      final notificationTime = appointmentTime.subtract(const Duration(minutes: 15));

      if (notificationTime.isAfter(DateTime.now())) {
        NotificationService.scheduleNotification(id: appointmentTime.millisecondsSinceEpoch ~/ 1000, title: 'Appointment Reminder', body: 'You have an appointment with $doctorName in 15 minutes!', scheduledTime: notificationTime);
      }

      // Show immediate confirmation
      NotificationService.showNotification(id: DateTime.now().millisecondsSinceEpoch ~/ 1000, title: 'Appointment Confirmed!', body: 'Your appointment with $doctorName on $date at $_selectedTimeSlot is confirmed.');

      _showConfirmationDialog('Booking Successful!', 'Your appointment with $doctorName on $date at $_selectedTimeSlot has been confirmed.');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  Future<void> _rescheduleAppointment() async {
    if (_selectedDay == null || _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a date and time slot'), backgroundColor: Colors.red));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String doctorName = widget.doctorData['name'];
    final String date = _selectedDay.toString().split(' ')[0];

    final result = await _appointmentService.rescheduleAppointment(appointmentId: widget.appointmentId!, newDate: _selectedDay!, newTimeSlot: _selectedTimeSlot!);

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      _scheduleNotification(doctorName, date);
      _showConfirmationDialog('Reschedule Successful!', 'Your appointment with $doctorName has been rescheduled to $date at $_selectedTimeSlot.');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  void _scheduleNotification(String doctorName, String date) {
    // Schedule notification 15 minutes before
    // This helper re-uses logic or just accepts passed values.
    // Ideally we re-calculate or just assume logic is handled in _bookAppointment.
    // But since _rescheduleAppointment calls this, we need the logic here or extracted.
    // For now, let's keep it simple or copy logic if needed.
    // Actually, based on previous code, this helper is needed.

    // We need to parse _selectedTimeSlot to get hour/minute
    final timeParts = _selectedTimeSlot!.split(' '); // "09:00" "AM"
    final time = timeParts[0].split(':');
    int hour = int.parse(time[0]);
    final int minute = int.parse(time[1]);
    if (timeParts[1] == 'PM' && hour != 12) hour += 12;
    if (timeParts[1] == 'AM' && hour == 12) hour = 0;

    final appointmentTime = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day, hour, minute);
    final notificationTime = appointmentTime.subtract(const Duration(minutes: 15));

    if (notificationTime.isAfter(DateTime.now())) {
      NotificationService.scheduleNotification(id: appointmentTime.millisecondsSinceEpoch ~/ 1000, title: 'Appointment Reminder', body: 'You have an appointment with $doctorName in 15 minutes!', scheduledTime: notificationTime);
    }
  }

  void _showConfirmationDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(
            title,
            style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: AppColors.madiBlue),
          ),
          content: Text(
            content,
            style: TextStyle(fontFamily: 'Ubuntu', color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainLayoutScreen(initialIndex: 1)), (Route<dynamic> route) => false);
              },
              child: Text(
                'Done',
                style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: AppColors.madiBlue),
              ),
            ),
          ],
        );
      },
    );
  }
}
