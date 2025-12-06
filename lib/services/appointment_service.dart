import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Book an appointment
  Future<Map<String, dynamic>> bookAppointment({required String userId, required String doctorId, required String doctorName, required String patientName, required DateTime date, required String timeSlot, required String status, String? doctorImage}) async {
    try {
      await _firestore.collection('appointments').add({'userId': userId, 'doctorId': doctorId, 'doctorName': doctorName, 'doctorImage': doctorImage, 'patientName': patientName, 'date': Timestamp.fromDate(date), 'timeSlot': timeSlot, 'status': status, 'createdAt': FieldValue.serverTimestamp()});

      return {'success': true, 'message': 'Appointment booked successfully'};
    } catch (e) {
      return {'success': false, 'message': 'Failed to book appointment: $e'};
    }
  }

  // Get appointments for a user
  Stream<QuerySnapshot> getAppointments(String userId) {
    return _firestore.collection('appointments').where('userId', isEqualTo: userId).orderBy('date', descending: false).snapshots();
  }

  // Cancel an appointment
  Future<void> cancelAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).update({'status': 'Cancelled'});
  }

  // Delete an appointment
  Future<void> deleteAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).delete();
  }

  // Reschedule an appointment
  Future<Map<String, dynamic>> rescheduleAppointment({required String appointmentId, required DateTime newDate, required String newTimeSlot}) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({'date': Timestamp.fromDate(newDate), 'timeSlot': newTimeSlot, 'status': 'Rescheduled', 'updatedAt': FieldValue.serverTimestamp()});

      return {'success': true, 'message': 'Appointment rescheduled successfully'};
    } catch (e) {
      return {'success': false, 'message': 'Failed to reschedule appointment: $e'};
    }
  }
}
