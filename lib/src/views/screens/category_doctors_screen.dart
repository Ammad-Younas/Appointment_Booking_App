// lib/src/views/screens/category_doctors_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/doctor_card.dart';
// --- MODIFICATION: Import the new service ---
import 'package:appointment_booking_app/services/doctor_service.dart';

class CategoryDoctorsScreen extends StatefulWidget {
  final String? categoryName;
  const CategoryDoctorsScreen({super.key, this.categoryName});

  @override
  State<CategoryDoctorsScreen> createState() => _CategoryDoctorsScreenState();
}

class _CategoryDoctorsScreenState extends State<CategoryDoctorsScreen> {

  // --- MODIFICATION: Get data from the service ---
  List<Doctor> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    // This logic now works perfectly
    if (widget.categoryName != null) {
      _filteredDoctors = DoctorService.getDoctorsByCategory(widget.categoryName!);
    } else {
      // categoryName is null, so "See All" was clicked
      _filteredDoctors = DoctorService.getAllDoctors();
    }
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appointly',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.madiBlue,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                widget.categoryName ?? 'All Doctors', // Title is now correct
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30.0),

              // --- MODIFICATION: Use the Doctor model ---
              if (_filteredDoctors.isEmpty)
                Center(
                  child: Text(
                    'No doctors found for this category.',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16.0,
                      color: AppColors.madiGrey,
                    ),
                  ),
                )
              else
                ..._filteredDoctors.map((doctor) {
                  return DoctorCard(doctor: doctor.toMap());
                }).toList(),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}