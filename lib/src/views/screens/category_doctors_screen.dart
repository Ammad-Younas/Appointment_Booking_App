import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/doctor_card.dart';

class CategoryDoctorsScreen extends StatefulWidget {
  final String? categoryName;
  const CategoryDoctorsScreen({super.key, this.categoryName});

  @override
  State<CategoryDoctorsScreen> createState() => _CategoryDoctorsScreenState();
}

class _CategoryDoctorsScreenState extends State<CategoryDoctorsScreen> {
  // Sample data for all doctors
  final List<Map<String, dynamic>> _allDoctors = [
    // Nerologists
    {
      'name': 'Dr. Assad Abbas',
      'specialty': 'Nerologist',
      'rating': 4.5,
      'price': 28,
      'slots': 5,
      'image': 'assets/images/doctor_1.png',
    },
    {
      'name': 'Dr. Aliyah Khan',
      'specialty': 'Nerologist',
      'rating': 4.8,
      'price': 35,
      'slots': 3,
      'image': 'assets/images/doctor_female.png', // You'd add this image
    },
    // Cardiologists
    {
      'name': 'Dr. Farhan Ahmed',
      'specialty': 'Cardiologist',
      'rating': 4.7,
      'price': 40,
      'slots': 2,
      'image': 'assets/images/doctor_male2.png', // You'd add this image
    },
    // Dentists
    {
      'name': 'Dr. Kamran',
      'specialty': 'Dentist',
      'rating': 4.3,
      'price': 25,
      'slots': 5,
      'image': 'assets/images/doctor_2.png',
    },
    {
      'name': 'Dr. Sara Ali',
      'specialty': 'Dentist',
      'rating': 4.6,
      'price': 30,
      'slots': 8,
      'image': 'assets/images/doctor_female2.png', // You'd add this image
    },
    // Therapists
    {
      'name': 'Dr. Bilal Qureshi',
      'specialty': 'Therapist',
      'rating': 4.4,
      'price': 22,
      'slots': 6,
      'image': 'assets/images/doctor_male3.png', // You'd add this image
    },
  ];

  List<Map<String, dynamic>> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    if (widget.categoryName != null) {
      // Filter the doctors list based on the passed category name
      _filteredDoctors = _allDoctors
          .where((doctor) => doctor['specialty'] == widget.categoryName)
          .toList();
    } else {
      // If no categoryName is passed, show all doctors
      _filteredDoctors = _allDoctors;
    }
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Category Title
              Text(
                widget.categoryName ?? 'All Doctors',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30.0),

              // Filtered Doctors List
              if (_filteredDoctors.isEmpty)
                Center(
                  child: Text(
                    'No doctors found for this category.',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16.0,
                      color: AppColors.madiGrey,
                    ),
                  ),
                )
              else
                ..._filteredDoctors.map((doctor) {
                  // --- THIS IS THE ONLY CHANGE ---
                  return DoctorCard(doctor: doctor);
                }).toList(),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // Copied this from your home_screen.dart for consistent UI
  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.calendar_today_outlined, 'Appointments', 1),
          _buildNavItem(Icons.notifications_outlined, 'Notifications', 2),
          _buildNavItem(Icons.settings_outlined, 'Settings', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = index == 0;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
        // TODO: Handle navigation for other tabs
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.madiBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4.0),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 10.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}