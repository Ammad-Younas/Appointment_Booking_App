// lib/src/views/screens/main_layout_screen.dart
import 'package:flutter/material.dart';
import 'package:appointment_booking_app/src/views/screens/home_screen.dart';
import 'package:appointment_booking_app/src/views/screens/my_appointments_screen.dart';
import 'package:appointment_booking_app/src/views/widgets/app_bottom_nav_bar.dart';
import 'package:appointment_booking_app/src/views/screens/notifications_screen.dart';
// --- MODIFICATION ---
import 'package:appointment_booking_app/src/views/screens/settings_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  final int initialIndex;
  const MainLayoutScreen({super.key, this.initialIndex = 0});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  late int _currentIndex;

  // The list of all your main pages
  final List<Widget> _pages = [
    const HomeScreen(),
    const MyAppointmentsScreen(),
    const NotificationsScreen(),
    // --- MODIFICATION ---
    const SettingsScreen(), // Replaced placeholder
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}