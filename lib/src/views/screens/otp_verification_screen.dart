import 'package:appointment_booking_app/src/views/screens/update_password_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // Create controllers and focus nodes for each box
  final _pin1Controller = TextEditingController();
  final _pin2Controller = TextEditingController();
  final _pin3Controller = TextEditingController();
  final _pin4Controller = TextEditingController();

  final _pin1Focus = FocusNode();
  final _pin2Focus = FocusNode();
  final _pin3Focus = FocusNode();
  final _pin4Focus = FocusNode();

  @override
  void dispose() {
    // Clean up all controllers and focus nodes
    _pin1Controller.dispose();
    _pin2Controller.dispose();
    _pin3Controller.dispose();
    _pin4Controller.dispose();
    _pin1Focus.dispose();
    _pin2Focus.dispose();
    _pin3Focus.dispose();
    _pin4Focus.dispose();
    super.dispose();
  }

  // Helper widget for a single OTP input box
  Widget _buildOtpBox(TextEditingController controller, FocusNode currentFocus, FocusNode? nextFocus, FocusNode? prevFocus) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextFormField(
        controller: controller,
        focusNode: currentFocus,
        onChanged: (value) {
          if (value.length == 1 && nextFocus != null) {
            // Move to the next box if a number is entered
            nextFocus.requestFocus();
          } else if (value.isEmpty && prevFocus != null) {
            // Move to the previous box if delete is pressed
            prevFocus.requestFocus();
          }
        },
        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.madiGrey.withAlpha(77),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide.none),
          // Remove the default padding
          contentPadding: EdgeInsets.zero,
        ),
      ),
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

              // OTP Verification Title
              Text(
                'OTP Verification',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 28.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
              ),
              const SizedBox(height: 40.0),

              // Enter OTP Label
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Text(
                  'Enter OTP',
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColors.madiGrey),
                ),
              ),
              const SizedBox(height: 24.0),

              // OTP Input Boxes
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_buildOtpBox(_pin1Controller, _pin1Focus, _pin2Focus, null), _buildOtpBox(_pin2Controller, _pin2Focus, _pin3Focus, _pin1Focus), _buildOtpBox(_pin3Controller, _pin3Focus, _pin4Focus, _pin2Focus), _buildOtpBox(_pin4Controller, _pin4Focus, null, _pin3Focus)]),
              const SizedBox(height: 60.0),

              // Verify OTP Button
              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: () {
                    // Combine the controllers to get the full OTP
                    String otp = _pin1Controller.text + _pin2Controller.text + _pin3Controller.text + _pin4Controller.text;

                    debugPrint('Verify OTP Button Pressed!');
                    debugPrint('Full OTP: $otp');

                    // Validate OTP input
                    if (otp.length == 4) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UpdatePasswordScreen()));
                    } else {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a complete 4-digit OTP'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.madiBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Verify OTP',
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
