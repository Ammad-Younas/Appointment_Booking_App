import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/src/views/screens/login_screen.dart';
import 'package:appointment_booking_app/src/views/screens/patient_profile_screen.dart';
// Import the new screens
import 'package:appointment_booking_app/src/views/screens/theme_settings_screen.dart';
import 'package:appointment_booking_app/src/views/screens/content_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy content for the reusable content pages
    const String privacyPolicyContent =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ... (Your full privacy policy text here)';
    const String aboutAppContent =
        'Appointly v1.0.0. This app helps you book appointments with top doctors... (Your full about text here)';
    const String contactUsContent =
        'For support, please email us at:\nsupport@appointly.com\n\nOr call us at:\n+1 (800) 555-1234';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        // --- MODIFICATION: No AppBar ---
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                // --- MODIFICATION: Added consistent header ---
                Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30.0),

                // --- MODIFICATION: Updated settings options ---
                _buildSettingItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        // Links to your existing profile screen
                        builder: (context) => const PatientProfileScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.palette_outlined,
                  title: 'Themes',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ThemeSettingsScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ContentScreen(
                          title: 'Privacy Policy',
                          content: privacyPolicyContent,
                        ),
                      ),
                    );
                  },
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'About App',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ContentScreen(
                          title: 'About App',
                          content: aboutAppContent,
                        ),
                      ),
                    );
                  },
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.contact_support_outlined,
                  title: 'Contact Us',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ContentScreen(
                          title: 'Contact Us',
                          content: contactUsContent,
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                // --- Logout Button (remains the same) ---
                _buildSettingItem(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  color: Colors.red,
                  onTap: () {
                    // Navigate to Login and clear all previous routes
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                          (Route<dynamic> route) => false,
                    );
                  },
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        Color color = Colors.black,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Ubuntu',
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: color,
        size: 18,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
    );
  }
}