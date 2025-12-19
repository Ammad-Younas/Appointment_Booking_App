import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appointment_booking_app/services/auth_service.dart';
import 'package:appointment_booking_app/src/views/screens/login_screen.dart';
import 'package:appointment_booking_app/src/views/screens/doctor_profile_screen.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';

class DoctorProfileTab extends StatelessWidget {
  const DoctorProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return const Center(child: Text('Not logged in'));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Text(
              'Profile',
              style: TextStyle(fontFamily: 'Ubuntu', fontSize: 28.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
            ),
            const SizedBox(height: 30.0),

            // Doctor Info Card with FutureBuilder
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('doctors').doc(user.uid).get(),
              builder: (context, snapshot) {
                String displayName = user.email ?? 'Doctor';
                // Try to get name from doctors collection, fallback to users collection, fallback to email
                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  displayName = data['name'] ?? displayName;
                }

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.madiBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.madiBlue,
                        child: const Icon(Icons.person, size: 30, color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
                            ),
                            Text(
                              'Doctor Account',
                              style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14, color: AppColors.madiGrey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // Options List
            _buildOptionTile(
              context,
              icon: Icons.edit,
              title: 'Update Profile',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DoctorProfileScreen()));
              },
            ),

            _buildOptionTile(
              context,
              icon: Icons.logout,
              title: 'Logout',
              color: Colors.red,
              onTap: () async {
                await _authService.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: (color ?? AppColors.madiBlue).withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color ?? AppColors.madiBlue),
        ),
        title: Text(
          title,
          style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: color ?? Theme.of(context).textTheme.titleLarge?.color),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}
