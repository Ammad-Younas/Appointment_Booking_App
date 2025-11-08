import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';

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
      'specialty': 'Neurologist',
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
                                // TODO: Navigate to all doctors
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
                          return _buildDoctorCard(
                            name: doctor['name'],
                            specialty: doctor['specialty'],
                            rating: doctor['rating'],
                            price: doctor['price'],
                            slots: doctor['slots'],
                            imagePath: doctor['image'],
                          );
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
    return Column(
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
    );
  }

  // Doctor Card Widget
  Widget _buildDoctorCard({
    required String name,
    required String specialty,
    required double rating,
    required int price,
    required int slots,
    String? imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          // Main shadow for depth
          BoxShadow(
            color: AppColors.madiBlue.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
          // Secondary shadow for 3D effect
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Image with 3D effect
              Container(
                width: 100,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.madiBlue.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: imagePath != null
                      ? Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[400],
                      );
                    },
                  )
                      : Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              const SizedBox(width: 16.0),

              // Doctor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating with elevated style
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Specialty
                    Text(
                      specialty,
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 14.0,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4.0),

                    // Doctor Name
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Price
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 16.0,
                        ),
                        children: [
                          TextSpan(
                            text: '\$$price/',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'session',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Favorite Icon with elevated effect
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                  onPressed: () {
                    print('Favorite pressed for $name');
                    // TODO: Add to favorites
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Availability and Book Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 14.0,
                  ),
                  children: [
                    TextSpan(
                      text: 'Availability ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: '• $slots Slots',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  print('Book appointment for $name');
                  // TODO: Navigate to booking screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.madiBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  elevation: 8,
                  shadowColor: AppColors.madiBlue.withOpacity(0.4),
                ),
                child: Text(
                  'Book Appointment',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
