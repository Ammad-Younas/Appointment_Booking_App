import 'package:appointment_booking_app/src/views/screens/schedule_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/app_text_field.dart';

class PatientDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> doctorData;
  const PatientDetailsScreen({super.key, required this.doctorData});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  // Controllers for text fields
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = 'Male';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // Helper widget for section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Ubuntu',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: AppColors.madiBlue,
        ),
      ),
    );
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
            children: <Widget>[
              // Header Title
              Text(
                'Appointly',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.madiBlue,
                ),
              ),
              const SizedBox(height: 10.0),

              // Page Title
              Text(
                'Add Patient Details',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30.0),

              // Full Name
              AppTextField(
                controller: _nameController,
                hintText: 'Full Name',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16.0),

              // Phone Number
              AppTextField(
                controller: _phoneController,
                hintText: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),

              // Age
              AppTextField(
                controller: _ageController,
                hintText: 'Age',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24.0),

              // Gender Selection (copied from your patient_profile_screen)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gender',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      _buildGenderToggle('Male'),
                      const SizedBox(width: 16.0),
                      _buildGenderToggle('Female'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 60.0),

              // Schedule Appointment Button
              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: () {
                    // Validation
                    if (_nameController.text.isEmpty ||
                        _phoneController.text.isEmpty ||
                        _ageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill all fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Collect patient data
                    final patientData = {
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      'age': _ageController.text,
                      'gender': _selectedGender,
                    };

                    // Navigate to Schedule Screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ScheduleAppointmentScreen(
                          doctorData: widget.doctorData,
                          patientData: patientData,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.madiBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Schedule Appointment',
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

  Widget _buildGenderToggle(String gender) {
    return Row(
      children: [
        Text(
          gender,
          style: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 14.0,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8.0),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedGender = gender;
            });
          },
          child: Container(
            width: 50,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _selectedGender == gender
                  ? AppColors.madiBlue.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: _selectedGender == gender
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedGender == gender
                      ? AppColors.madiBlue
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}