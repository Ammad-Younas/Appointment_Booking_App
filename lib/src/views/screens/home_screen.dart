// lib/src/views/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/screens/category_doctors_screen.dart';
import 'package:appointment_booking_app/src/views/widgets/doctor_card.dart';
import 'package:appointment_booking_app/src/views/screens/notifications_screen.dart';
// --- MODIFICATION: Import the new service ---
import 'package:appointment_booking_app/services/doctor_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // --- MODIFICATION: Get data from the service ---
  final List<Doctor> _topDoctors = DoctorService.getTopDoctors();

  // Specialty categories (this can stay hardcoded)
  final List<Map<String, dynamic>> _specialties = [
    {'name': 'Nerologist', 'icon': Icons.psychology},
    {'name': 'Cardiologist', 'icon': Icons.favorite},
    {'name': 'Dentist', 'icon': Icons.healing},
    // Added a category from your service
    {'name': 'Therapist', 'icon': Icons.medical_services},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                // Header Section
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

                // Specialty Categories
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _specialties.map((specialty) {
                    return _buildSpecialtyCard(
                      specialty['name'],
                      specialty['icon'],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30.0),

                // Top Doctors Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Doctors',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // --- MODIFICATION: "See All" now works ---
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            // Pass null to show all doctors
                            builder: (context) => const CategoryDoctorsScreen(categoryName: null),
                          ),
                        );
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.madiBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Top Doctors List
                // --- MODIFICATION: Use the Doctor model ---
                ..._topDoctors.map((doctor) {
                  return DoctorCard(doctor: doctor.toMap());
                }).toList(),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Specialty Card Widget
  Widget _buildSpecialtyCard(String name, IconData icon) {
    return GestureDetector(
      onTap: () {
        // --- MODIFICATION: This now works ---
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryDoctorsScreen(categoryName: name),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 35,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}