import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';

class ContentScreen extends StatelessWidget {
  final String title;
  final String content;

  const ContentScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                decoration: BoxDecoration(color: AppColors.madiBlue.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: Center(child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).iconTheme.color, size: 18)),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 28.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
              ),
              const SizedBox(height: 30.0),
              Text(
                content,
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
