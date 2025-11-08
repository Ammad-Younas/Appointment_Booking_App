import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/app_text_field.dart';
import 'package:appointment_booking_app/src/views/screens/home_screen.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  // Controllers for text fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _currentMedicationsController = TextEditingController();
  final _medicalHistoryController = TextEditingController();

  // Selection variables
  String _selectedGender = 'Male';
  String? _selectedBloodGroup;
  String? _selectedMaritalStatus;

  // Lists for dropdowns
  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  final List<String> _maritalStatuses = [
    'Single', 'Married', 'Divorced', 'Widowed'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    _currentMedicationsController.dispose();
    _medicalHistoryController.dispose();
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

  // Helper widget for dropdown with checkmark
  Widget _buildDropdownWithCheck(String label, String? value, List<String> items, String hint) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: AppColors.madiLight,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  hint: Text(
                    hint,
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16.0,
                      color: AppColors.madiGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  icon: const SizedBox.shrink(),
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      if (label == 'Blood Group') {
                        _selectedBloodGroup = newValue;
                      } else if (label == 'Marital Status') {
                        _selectedMaritalStatus = newValue;
                      }
                    });
                  },
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ],
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

              // Create Profile subtitle
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Create, ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Patient Profile',
                      style: TextStyle(color: AppColors.madiBlue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),

              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.madiGrey.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: AppColors.madiGrey.withOpacity(0.5),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.madiBlue,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          onPressed: () {
                            print('Edit Profile Picture Pressed!');
                            // TODO: Implement image picking logic
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PERSONAL INFORMATION SECTION
              _buildSectionHeader('Personal Information'),

              // Full Name
              AppTextField(
                controller: _nameController,
                hintText: 'Full Name',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16.0),

              // Email
              AppTextField(
                controller: _emailController,
                hintText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
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

              // Gender Selection with Toggle Switches
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
                      // Male Toggle
                      Text(
                        'Male',
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
                            _selectedGender = 'Male';
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _selectedGender == 'Male'
                                ? AppColors.madiBlue.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.2),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            alignment: _selectedGender == 'Male'
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _selectedGender == 'Male'
                                    ? AppColors.madiBlue
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      // Female Toggle
                      Text(
                        'Female',
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
                            _selectedGender = 'Female';
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _selectedGender == 'Female'
                                ? AppColors.madiBlue.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.2),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            alignment: _selectedGender == 'Female'
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _selectedGender == 'Female'
                                    ? AppColors.madiBlue
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Blood Group Dropdown
              _buildDropdownWithCheck('Blood Group', _selectedBloodGroup, _bloodGroups, 'Select'),
              const SizedBox(height: 24.0),

              // Marital Status Dropdown
              _buildDropdownWithCheck('Marital Status', _selectedMaritalStatus, _maritalStatuses, 'Select'),
              const SizedBox(height: 16.0),

              // Address
              AppTextField(
                controller: _addressController,
                hintText: 'Complete Address',
                keyboardType: TextInputType.streetAddress,
              ),

              // MEDICAL INFORMATION SECTION
              _buildSectionHeader('Medical Information'),

              // Height
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _heightController,
                      hintText: 'Height (cm)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: AppTextField(
                      controller: _weightController,
                      hintText: 'Weight (kg)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Allergies
              AppTextField(
                controller: _allergiesController,
                hintText: 'Known Allergies (if any)',
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16.0),

              // Current Medications
              AppTextField(
                controller: _currentMedicationsController,
                hintText: 'Current Medications (if any)',
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16.0),

              // Medical History
              AppTextField(
                controller: _medicalHistoryController,
                hintText: 'Past Medical History / Chronic Conditions',
                keyboardType: TextInputType.multiline,
              ),

              // EMERGENCY CONTACT SECTION
              _buildSectionHeader('Emergency Contact'),

              // Emergency Contact
              AppTextField(
                controller: _emergencyContactController,
                hintText: 'Emergency Contact (Name & Phone)',
                keyboardType: TextInputType.text,
              ),

              const SizedBox(height: 40.0),

              // Save Profile Button
              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: () {
                    // Validation and save logic
                    if (_nameController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _phoneController.text.isEmpty ||
                        _selectedBloodGroup == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill all required fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    print('=== PATIENT PROFILE ===');
                    print('Name: ${_nameController.text}');
                    print('Email: ${_emailController.text}');
                    print('Phone: ${_phoneController.text}');
                    print('Age: ${_ageController.text}');
                    print('Gender: $_selectedGender');
                    print('Blood Group: $_selectedBloodGroup');
                    print('Marital Status: $_selectedMaritalStatus');
                    print('Address: ${_addressController.text}');
                    print('Height: ${_heightController.text}');
                    print('Weight: ${_weightController.text}');
                    print('Allergies: ${_allergiesController.text}');
                    print('Current Medications: ${_currentMedicationsController.text}');
                    print('Medical History: ${_medicalHistoryController.text}');
                    print('Emergency Contact: ${_emergencyContactController.text}');

                    // TODO: Save to database/backend
                    // TODO: Navigate to Home Screen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                    'Save Profile',
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
}