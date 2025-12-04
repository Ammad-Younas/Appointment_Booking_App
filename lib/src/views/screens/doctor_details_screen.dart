import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/screens/patient_details_screen.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const DoctorDetailsScreen({super.key, required this.doctorData});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  // Helper widget for section headers
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
    );
  }

  // Helper widget for section content
  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.madiGrey, height: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract data for easier access
    final String name = widget.doctorData['name'] ?? 'Doctor Name';
    final String specialty = widget.doctorData['specialty'] ?? 'Specialty';
    final double rating = (widget.doctorData['rating'] ?? 0.0).toDouble();
    final String? imagePath = widget.doctorData['image'];
    final int price = widget.doctorData['price'] ?? 0;
    final int slots = widget.doctorData['slots'] ?? 0;
    // Get new data from the map (populated by DoctorService)
    final String about = widget.doctorData['about'] ?? 'No details available.';
    final String qualification = widget.doctorData['qualification'] ?? 'No details available.';
    final String location = widget.doctorData['location'] ?? 'No details available.';

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
                child: Center(child: Icon(Icons.arrow_back_ios_new, color: AppColors.madiGrey, size: 18)),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Text(
                'Appointly',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 34.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
              ),
              const SizedBox(height: 10.0),

              // Page Title
              Text(
                'Doctor Details',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 28.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
              ),
              const SizedBox(height: 30.0),

              // --- Doctor Info Card ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18.0),
                      child: Container(
                        width: 100,
                        height: 120,
                        color: Colors.grey[200],
                        child: imagePath != null
                            ? (imagePath.startsWith('http')
                                  ? Image.network(
                                      imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.person, size: 60, color: Colors.grey[400]);
                                      },
                                    )
                                  : Image.asset(
                                      imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.person, size: 60, color: Colors.grey[400]);
                                      },
                                    ))
                            : Icon(Icons.person, size: 60, color: Colors.grey[400]),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    // Doctor Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(fontFamily: 'Ubuntu', fontSize: 22.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            specialty,
                            style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, fontWeight: FontWeight.w500, color: AppColors.madiGrey),
                          ),
                          const SizedBox(height: 16.0),
                          // Rating
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                const SizedBox(width: 4.0),
                                Text(
                                  rating.toString(),
                                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14.0, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            children: [
                              Icon(Icons.monetization_on_outlined, color: AppColors.madiGrey, size: 18),
                              const SizedBox(width: 8.0),
                              Text(
                                '\$$price / session',
                                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 15.0, fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.bodyLarge?.color),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(Icons.event_available_outlined, color: AppColors.madiGrey, size: 18),
                              const SizedBox(width: 8.0),
                              Text(
                                '$slots Slots Available',
                                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 15.0, fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.bodyLarge?.color),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),

              // --- About Section ---
              _buildSectionHeader('About'),
              const SizedBox(height: 8.0),
              _buildSectionContent(about),
              const SizedBox(height: 30.0),

              // --- Qualification Section ---
              _buildSectionHeader('Qualification'),
              const SizedBox(height: 8.0),
              _buildSectionContent(qualification),
              const SizedBox(height: 30.0),

              // --- Location Section ---
              _buildSectionHeader('Location'),
              const SizedBox(height: 8.0),
              _buildSectionContent(location),
              const SizedBox(height: 40.0),

              // --- Book Appointment Button ---
              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PatientDetailsScreen(doctorData: widget.doctorData)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.madiBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Book Appointment',
                    style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
        // No bottom navigation bar on this sub-page
      ),
    );
  }
}
