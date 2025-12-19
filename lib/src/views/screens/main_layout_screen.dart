// lib/src/views/screens/main_layout_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appointment_booking_app/src/views/screens/home_screen.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/screens/doctor_home_screen.dart';
import 'package:appointment_booking_app/src/views/screens/my_appointments_screen.dart';
import 'package:appointment_booking_app/src/views/screens/settings_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  final int initialIndex;
  const MainLayoutScreen({super.key, this.initialIndex = 0});

  @override
  State<MainLayoutScreen> createState() => MainLayoutScreenState();
}

class MainLayoutScreenState extends State<MainLayoutScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    // Check if current user is a doctor
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          String role = (doc.data() as Map<String, dynamic>)['role'] ?? 'patient';
          if (role == 'doctor') {
            // Navigate to Doctor Home
            if (mounted) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DoctorHomeScreen()));
            }
          } else {
            // Stay here (Patient Home)
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          // User document not found, assume patient or handle as error
          setState(() => _isLoading = false);
        }
      } catch (e) {
        debugPrint('Error checking role: $e');
        setState(() => _isLoading = false);
      }
    } else {
      // No user logged in, assume patient or redirect to login
      setState(() => _isLoading = false);
    }
  }

  int _selectedIndex = 0;
  final List<Widget> _screens = [const HomeScreen(), const MyAppointmentsScreen(), const SettingsScreen()];

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: AppColors.madiBlue,
        unselectedItemColor: Theme.of(context).disabledColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
