import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme Settings',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30.0),
              // You can add theme options here
              ListTile(
                title: Text(
                  'Colorblind Mode (Protanopia)',
                  style: TextStyle(fontFamily: 'Ubuntu'),
                ),
                trailing: Switch(
                  value: false,
                  onChanged: (bool value) {
                    // TODO: Implement theme change logic
                  },
                  activeColor: AppColors.madiBlue,
                ),
              ),
              ListTile(
                title: Text(
                  'Colorblind Mode (Deuteranopia)',
                  style: TextStyle(fontFamily: 'Ubuntu'),
                ),
                trailing: Switch(
                  value: false,
                  onChanged: (bool value) {
                    // TODO: Implement theme change logic
                  },
                  activeColor: AppColors.madiBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}