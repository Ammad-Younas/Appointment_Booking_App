import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/screens/category_doctors_screen.dart';
import 'package:appointment_booking_app/src/views/widgets/doctor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Sample data for doctors
  final List<Map<String, dynamic>> _topDoctors = [
    {
      'name': 'Dr. Assad Abbas',
      'specialty': 'Nerologist',
      'rating': 4.5,
      'price': 28,
      'slots': 5,
      'image': 'assets/images/doctor_1.png',
    },
    {
      'name': 'Dr. Kamran',
      'specialty': 'Dentist',
      'rating': 4.3,
      'price': 25,
      'slots': 5,
      'image': 'assets/images/doctor_2.png',
    },
    {
      'name': 'Dr. Kamran',
      'specialty': 'Dentist',
      'rating': 4.3,
      'price': 25,
      'slots': 5,
      'image': 'assets/images/doctor_2.png',
    },
  ];

  // Specialty categories
  final List<Map<String, dynamic>> _specialties = [
    {'name': 'Nerologist', 'icon': Icons.psychology},
    {'name': 'Cardiologist', 'icon': Icons.favorite},
    {'name': 'Therapist', 'icon': Icons.medical_services},
    {'name': 'Dentist', 'icon': Icons.healing},
  ];

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Handle navigation to different screens
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Main Content
              Expanded(
                child: SingleChildScrollView(
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
                                  print('Notification pressed');
                                  // TODO: Navigate to notifications
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
                                print('See all doctors');
                                // Navigate to the doctors list screen without a category
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const CategoryDoctorsScreen(),
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
                        ..._topDoctors.map((doctor) {
                          // --- THIS IS THE ONLY CHANGE ---
                          return DoctorCard(doctor: doctor);
                        }).toList(),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Navigation Bar
              _buildBottomNavigationBar(),
            ],
          ),
        ),
      ),
    );
  }

  // Specialty Card Widget
  Widget _buildSpecialtyCard(String name, IconData icon) {
    return GestureDetector(
      onTap: () {
        print('Tapped on category: $name');
        // Navigate to the new doctor list screen
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

  // Bottom Navigation Bar
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
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onNavBarTap(index),
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