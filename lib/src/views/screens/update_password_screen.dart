import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/app_text_field.dart';
import 'package:appointment_booking_app/src/views/screens/patient_profile_screen.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
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
                decoration: BoxDecoration(
                  color: AppColors.madiBlue.withAlpha(57),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.madiGrey,
                    size: 18,
                  ),
                ),
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
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.madiBlue,
                ),
              ),
              const SizedBox(height: 70.0),

              // Update Password Title
              Text(
                'Update Password',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.madiBlue,
                ),
              ),
              const SizedBox(height: 40.0),

              // New password Label
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Text(
                  'New password',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.madiGrey,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              // New password Text Field
              AppTextField(
                controller: _newPasswordController,
                hintText: 'Enter new password',
                isPassword: true,
              ),
              const SizedBox(height: 24.0),

              // Confirm password Label
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Text(
                  'Confirm password',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.madiGrey,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              // Confirm password Text Field
              AppTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm new password',
                isPassword: true,
              ),
              const SizedBox(height: 30.0),

              // Update Password Button
              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PatientProfileScreen(),
                        ),
                    );
                    // TODO: Add logic to check passwords match and update
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.madiBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Update Password',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
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