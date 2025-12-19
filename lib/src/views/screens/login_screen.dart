// lib/src/views/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/app_text_field.dart';
import 'package:appointment_booking_app/src/views/screens/sign_up_screen.dart';
import 'package:appointment_booking_app/src/views/screens/forgot_password_screen.dart';
import 'package:appointment_booking_app/src/views/screens/main_layout_screen.dart';
import 'package:appointment_booking_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Login function
  Future<void> _handleLogin() async {
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
      _showErrorSnackBar('Please enter your password');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showErrorSnackBar('Password must be at least 6 characters');
      return;
    }

    // Show loading
    setState(() {
      _isLoading = true;
    });

    // Attempt login
    final result = await _authService.signInWithEmailPassword(email: _emailController.text.trim(), password: _passwordController.text);

    // Hide loading
    setState(() {
      _isLoading = false;
    });

    // Handle result
    if (result['success']) {
      if (mounted) {
        // Navigate to main screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainLayoutScreen()));
      }
    } else {
      if (result['message'] == 'Please verify your email before logging in.') {
        _showVerificationDialog();
      } else {
        _showErrorSnackBar(result['message']);
      }
    }
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Verification Required'),
        content: const Text('Please check your email and verify your account to proceed.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
        body: Stack(
          children: [
            SingleChildScrollView(
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

                  // Login Title
                  Text(
                    'Login',
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),

                  // Login Description
                  Text(
                    'Login to continue using App',
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
                  const SizedBox(height: 12.0),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(fontFamily: 'Ubuntu', color: AppColors.madiBlue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 55.0,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.madiBlue,
                        disabledBackgroundColor: AppColors.madiBlue.withOpacity(0.6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              'Login',
                              style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 60.0),

                  // Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 15.0, color: Colors.black),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(fontFamily: 'Ubuntu', fontSize: 15.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
