import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

              // Login Title
              Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),

              // Login Description
              Text(
                'Login to continue using App',
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
              const SizedBox(height: 12.0),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    print('Forgot Password Pressed!');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: AppColors.madiBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: () {
                    print('Login Button Pressed!');
                    print('Email: ${_emailController.text}');
                    print('Password: ${_passwordController.text}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.madiBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Login',
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

              // Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have an account? ",
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
                      print('Register Pressed!');
                    },
                    child: Text(
                      'Register',
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