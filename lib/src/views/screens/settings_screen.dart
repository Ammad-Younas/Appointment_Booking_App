// lib/src/views/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/src/views/screens/login_screen.dart';
import 'package:appointment_booking_app/src/views/screens/patient_profile_screen.dart';
import 'package:appointment_booking_app/src/views/screens/theme_settings_screen.dart';
import 'package:appointment_booking_app/src/views/screens/content_screen.dart';
import 'package:appointment_booking_app/services/auth_service.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _authService = AuthService();
  bool _isLoggingOut = false;

  // Dummy content for the reusable content pages
  static const String privacyPolicyContent =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ... (Your full privacy policy text here)';
  static const String aboutAppContent =
      'Appointly v1.0.0. This app helps you book appointments with top doctors... (Your full about text here)';
  static const String contactUsContent =
      'For support, please email us at:\nsupport@appointly.com\n\nOr call us at:\n+1 (800) 555-1234';

  // Handle logout
  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontFamily: 'Ubuntu'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: AppColors.madiGrey,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );

    // If user confirmed logout
    if (shouldLogout == true) {
      setState(() {
        _isLoggingOut = true;
      });

      try {
        // Sign out from Firebase
        await _authService.signOut();

        // Navigate to login screen and clear navigation stack
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
                (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        setState(() {
          _isLoggingOut = false;
        });

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to logout. Please try again.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
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
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
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

                    // Settings options
                    _buildSettingItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
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

                    // Logout Button
                    _buildSettingItem(
                      context,
                      icon: Icons.logout,
                      title: _isLoggingOut ? 'Logging out...' : 'Logout',
                      color: Colors.red,
                      onTap: _isLoggingOut ? () {} : _handleLogout,
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),

              // Loading overlay
              if (_isLoggingOut)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.madiBlue,
                    ),
                  ),
                ),
            ],
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