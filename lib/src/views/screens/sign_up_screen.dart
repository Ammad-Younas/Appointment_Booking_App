import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/app_text_field.dart';
import 'package:appointment_booking_app/src/views/screens/main_layout_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
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
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.madiBlue,
                ),
              ),
              const SizedBox(height: 70.0),

              // Sign Up Title
              Text(
                'Sign Up',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),

              // Sign Up Description
              Text(
                'Sign up to continue using App',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 16.0,
                  color: AppColors.madiGrey,
                ),
              ),
              const SizedBox(height: 40.0),

              // Email Label
              Text(
                'Email',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),

              // Email Text Field
              AppTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24.0),

              // Password Label
              Text(
                'Password',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),

              // Password Text Field
              AppTextField(
                controller: _passwordController,
                hintText: 'Enter password',
                isPassword: true,
              ),
              const SizedBox(height: 24.0),

              // Confirm Password Label
              Text(
                'Confirm Password',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),

              // Confirm Password Text Field
              AppTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm password',
                isPassword: true,
              ),
              const SizedBox(height: 30.0),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: () {
                    print('Sign Up Button Pressed!');
                    print('Email: ${_emailController.text}');
                    print('Password: ${_passwordController.text}');
                    // --- MODIFICATION ---
                    // Navigate to the MainLayoutScreen after sign up
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const MainLayoutScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.madiBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
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
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.madiBlue,
                      ),
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