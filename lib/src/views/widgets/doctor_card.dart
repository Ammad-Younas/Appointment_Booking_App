import 'package:flutter/material.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/screens/doctor_details_screen.dart';
import 'package:appointment_booking_app/src/views/screens/patient_details_screen.dart';

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final String name = doctor['name'] ?? 'Doctor Name';
    final String specialty = doctor['specialty'] ?? 'Specialty';
    final double rating = doctor['rating'] ?? 0.0;
    final int price = doctor['price'] ?? 0;
    final int slots = doctor['slots'] ?? 0;
    final String? imagePath = doctor['image'];

    // --- Main Card Tap ---
    return GestureDetector(
      onTap: () {
        // Tapping the main card goes to Doctor Details
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DoctorDetailsScreen(doctorData: doctor),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.madiBlue.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Image
                Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.madiBlue.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: imagePath != null
                        ? Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey[400],
                        );
                      },
                    )
                        : Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),

                // Doctor Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              rating.toString(),
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      // Specialty
                      Text(
                        specialty,
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 14.0,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4.0),

                      // Doctor Name
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      // Price
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 16.0,
                          ),
                          children: [
                            TextSpan(
                              text: '\$$price/',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'session',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Favorite Icon
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                    onPressed: () {
                      print('Favorite pressed for $name');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Availability and Book Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 14.0,
                      ),
                      children: [
                        TextSpan(
                          text: 'Availability ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '• $slots Slots',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  // --- MODIFICATION HERE (1st Request) ---
                  onPressed: () {
                    // This button now goes DIRECTLY to Patient Details
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PatientDetailsScreen(
                          doctorData: doctor,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.madiBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    elevation: 8,
                    shadowColor: AppColors.madiBlue.withOpacity(0.4),
                  ),
                  child: Text(
                    'Book Appointment',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}