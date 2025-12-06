// lib/src/views/screens/update_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/app_text_field.dart';
import 'package:appointment_booking_app/src/views/screens/login_screen.dart';
import 'package:appointment_booking_app/services/auth_service.dart';

class UpdatePasswordScreen extends StatefulWidget {
  final String? oobCode;
  const UpdatePasswordScreen({super.key, this.oobCode});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Update password function
  Future<void> _handleUpdatePassword() async {
    // Validate inputs
    if (_newPasswordController.text.isEmpty) {
      _showErrorSnackBar('Please enter a new password');
      return;
    }

    if (_newPasswordController.text.length < 6) {
      _showErrorSnackBar('Password must be at least 6 characters');
      return;
    }

    if (_confirmPasswordController.text.isEmpty) {
      _showErrorSnackBar('Please confirm your password');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    // Show loading
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> result;

    // Check if we are doing a reset (using oobCode) or an update (logged in user)
    if (widget.oobCode != null) {
      result = await _authService.confirmPasswordReset(code: widget.oobCode!, newPassword: _newPasswordController.text);
    } else {
      result = await _authService.updatePassword(newPassword: _newPasswordController.text);
    }

    // Hide loading
    setState(() {
      _isLoading = false;
    });

    // Handle result
    if (result['success']) {
      if (mounted) {
        // Show success dialog
        _showSuccessDialog();
      }
    } else {
      _showErrorSnackBar(result['message']);
    }
  }

  // Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 16.0),
              Text(
                'Password Updated!',
                style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: AppColors.madiBlue),
              ),
            ],
          ),
          content: Text(
            'Your password has been successfully updated. Please login with your new password.',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Ubuntu', color: AppColors.madiGrey),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to login screen and clear all previous routes
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  decoration: BoxDecoration(color: AppColors.madiBlue, borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    'Go to Login',
                    style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
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
                decoration: BoxDecoration(color: AppColors.madiBlue.withAlpha(57), shape: BoxShape.circle),
                child: Center(child: Icon(Icons.arrow_back_ios_new, color: AppColors.madiGrey, size: 18)),
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
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 34.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
              ),
              const SizedBox(height: 70.0),

              // Update Password Title
              Text(
                'Update Password',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 28.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
              ),
              const SizedBox(height: 16.0),

              // Description
              Text(
                'Please enter your new password. Make sure it is at least 6 characters long.',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14.0, color: AppColors.madiGrey, height: 1.5),
              ),
              const SizedBox(height: 40.0),

              // New password Label
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Text(
                  'New Password',
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(height: 8.0),

              // New password Text Field
              AppTextField(controller: _newPasswordController, hintText: 'Enter new password', isPassword: true),
              const SizedBox(height: 24.0),

              // Confirm password Label
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Text(
                  'Confirm Password',
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(height: 8.0),

              // Confirm password Text Field
              AppTextField(controller: _confirmPasswordController, hintText: 'Confirm new password', isPassword: true),
              const SizedBox(height: 30.0),

              // Update Password Button
              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleUpdatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.madiBlue,
                    disabledBackgroundColor: AppColors.madiBlue.withOpacity(0.6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                          'Update Password',
                          style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
