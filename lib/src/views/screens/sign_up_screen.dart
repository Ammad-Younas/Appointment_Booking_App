// lib/src/views/screens/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/app_text_field.dart';
import 'package:appointment_booking_app/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  String _selectedRole = 'patient';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Sign up function
  Future<void> _handleSignUp() async {
    // Validate inputs
    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      _showErrorSnackBar('Please enter a valid email address');
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter a password');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showErrorSnackBar('Password must be at least 6 characters');
      return;
    }

    if (_confirmPasswordController.text.isEmpty) {
      _showErrorSnackBar('Please confirm your password');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    // Show loading
    setState(() {
      _isLoading = true;
    });

    // Attempt sign up
    final result = await _authService.signUpWithEmailPassword(email: _emailController.text.trim(), password: _passwordController.text, role: _selectedRole);

    // Hide loading
    setState(() {
      _isLoading = false;
    });

    // Handle result
    if (result['success']) {
      if (mounted) {
        // Show success dialog
        showDialog(
          barrierDismissible: false, // Prevent dismissal by clicking outside
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Verify Email'),
            content: const Text('Account created! Please check your email to verify your account before logging in.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Navigate back to Login Screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50.0),

              // Header Title
              Text(
                'Appointly',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 34.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
              ),
              const SizedBox(height: 70.0),

              // Sign Up Title
              Text(
                'Sign Up',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8.0),

              // Sign Up Description
              Text(
                'Sign up to continue using App',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, color: AppColors.madiGrey),
              ),
              const SizedBox(height: 40.0),

              // Email Label
              Text(
                'Email',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8.0),

              // Email Text Field
              AppTextField(controller: _emailController, hintText: 'Enter your email', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 24.0),

              // Password Label
              Text(
                'Password',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8.0),

              // Password Text Field
              AppTextField(controller: _passwordController, hintText: 'Enter password', isPassword: true),
              const SizedBox(height: 24.0),

              // Confirm Password Label
              Text(
                'Confirm Password',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8.0),

              // Confirm Password Text Field
              AppTextField(controller: _confirmPasswordController, hintText: 'Confirm password', isPassword: true),
              const SizedBox(height: 24.0),

              // Role Selection
              Text(
                'I am a',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15.0)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRole,
                    isExpanded: true,
                    items: ['patient', 'doctor'].map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role == 'patient' ? 'Patient' : 'Doctor', style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.madiBlue,
                    disabledBackgroundColor: AppColors.madiBlue.withOpacity(0.6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                          'Sign Up',
                          style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 60.0),

              // Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Already have an account? ",
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 15.0, color: Colors.black),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // minimumSize: Size(50, 30),
                      // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontFamily: 'Ubuntu', fontSize: 15.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
