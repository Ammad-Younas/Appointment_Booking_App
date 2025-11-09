import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const DoctorDetailsScreen({super.key, required this.doctorData});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  GoogleMapController? _mapController;

  // Static location for "Metropolis" (based on your "Manhattan" map image)
  final LatLng _doctorLocation = const LatLng(40.7580, -73.9855);

  // Helper widget for section headers
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: AppColors.madiBlue,
      ),
    );
  }

  // Helper widget for section content
  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 16.0,
        color: AppColors.madiGrey,
        height: 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract data for easier access
    final String name = widget.doctorData['name'] ?? 'Doctor Name';
    final String specialty = widget.doctorData['specialty'] ?? 'Specialty';
    final double rating = widget.doctorData['rating'] ?? 0.0;
    final String? imagePath = widget.doctorData['image'];

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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 10.0),

                    // Page Title
                    Text(
                      'Doctor Details',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30.0),

                    // --- Doctor Info Card ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: AppColors.madiLight.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(24.0),
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
                                  ? Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.person, size: 60, color: Colors.grey[400]);
                                },
                              )
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
                                  style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  specialty,
                                  style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.madiGrey,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                // Rating
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 18),
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
                    _buildSectionContent(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Dr. $name has been a top $specialty for 10 years.',
                    ),
                    const SizedBox(height: 30.0),

                    // --- Qualification Section ---
                    _buildSectionHeader('Qualification'),
                    const SizedBox(height: 8.0),
                    _buildSectionContent(
                      '1. Lorem Ipsum is simply dummy text of the printing and typesetting.\n'
                          '2. Medical Degree from Metropolis University.\n'
                          '3. Board Certified in Neurology.',
                    ),
                    const SizedBox(height: 30.0),

                    // --- Location Section ---
                    _buildSectionHeader('Location'),
                    const SizedBox(height: 8.0),
                    _buildSectionContent(
                      'City Hospital, 123 Health St, Suite 405, Metropolis, USA',
                    ),
                    const SizedBox(height: 16.0),

                    // --- Google Map ---
                    // Make sure your API key is correctly set in AndroidManifest.xml
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: SizedBox(
                        height: 200,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: _doctorLocation,
                            zoom: 14.0,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                          },
                          markers: {
                            Marker(
                              markerId: MarkerId(name),
                              position: _doctorLocation,
                              infoWindow: InfoWindow(
                                title: name,
                                snippet: 'City Hospital',
                              ),
                            ),
                          },
                          zoomControlsEnabled: false,
                          scrollGesturesEnabled: false,
                          myLocationButtonEnabled: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),

                    // --- Book Appointment Button ---
                    SizedBox(
                      width: double.infinity,
                      height: 55.0,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Book Appointment pressed for $name');
                          // TODO: Navigate to Booking Screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.madiBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Book Appointment',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            ),
            // --- Bottom Navigation Bar ---
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  // Copied from home_screen.dart for UI consistency
  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.calendar_today_outlined, 'Appointments', 1),
          _buildNavItem(Icons.notifications_outlined, 'Notifications', 2),
          _buildNavItem(Icons.settings_outlined, 'Settings', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = index == 0;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.of(context).pop(); // Go back to the previous screen
        }
        // TODO: Handle other nav taps if necessary
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.madiBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4.0),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 10.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}