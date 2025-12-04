// lib/src/views/screens/category_doctors_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/doctor_card.dart';
import 'package:appointment_booking_app/services/doctor_service.dart';

class CategoryDoctorsScreen extends StatefulWidget {
  final String? categoryName;
  const CategoryDoctorsScreen({super.key, this.categoryName});

  @override
  State<CategoryDoctorsScreen> createState() => _CategoryDoctorsScreenState();
}

class _CategoryDoctorsScreenState extends State<CategoryDoctorsScreen> {
  final DoctorService _doctorService = DoctorService();
  late Stream<List<Doctor>> _doctorsStream;

  @override
  void initState() {
    super.initState();
    if (widget.categoryName != null) {
      _doctorsStream = _doctorService.getDoctorsByCategory(widget.categoryName!);
    } else {
      _doctorsStream = _doctorService.getDoctors();
    }
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appointly',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 34.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
              ),
              const SizedBox(height: 10.0),
              Text(
                widget.categoryName ?? 'All Doctors',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 28.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
              ),
              const SizedBox(height: 30.0),

              StreamBuilder<List<Doctor>>(
                stream: _doctorsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No doctors found for this category.',
                        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, color: AppColors.madiGrey),
                      ),
                    );
                  }

                  final doctors = snapshot.data!;
                  return Column(
                    children: doctors.map((doctor) {
                      return DoctorCard(doctor: doctor.toMap());
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
