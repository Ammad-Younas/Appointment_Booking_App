import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/app_text_field.dart';
import 'package:appointment_booking_app/src/views/screens/main_layout_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  // Controllers for text fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _currentMedicationsController = TextEditingController();
  final _medicalHistoryController = TextEditingController();

  // Selection variables
  String _selectedGender = 'Male';
  String? _selectedBloodGroup;
  String? _selectedMaritalStatus;
  bool _isLoading = false;
  File? _imageFile;
  String? _profileImageUrl;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Lists for dropdowns
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  final List<String> _maritalStatuses = ['Single', 'Married', 'Divorced', 'Widowed'];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? user.email ?? '';
          _phoneController.text = data['phone'] ?? '';
          _ageController.text = data['age'] ?? '';
          _addressController.text = data['address'] ?? '';
          _emergencyContactController.text = data['emergencyContact'] ?? '';
          _heightController.text = data['height'] ?? '';
          _weightController.text = data['weight'] ?? '';
          _allergiesController.text = data['allergies'] ?? '';
          _currentMedicationsController.text = data['currentMedications'] ?? '';
          _medicalHistoryController.text = data['medicalHistory'] ?? '';
          _profileImageUrl = data['profileImageUrl'];

          setState(() {
            _selectedGender = data['gender'] ?? 'Male';
            _selectedBloodGroup = data['bloodGroup'];
            _selectedMaritalStatus = data['maritalStatus'];
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  Future<String?> _uploadImage(String userId) async {
    if (_imageFile == null) return _profileImageUrl;

    try {
      final Reference ref = _storage.ref().child('user_profiles').child('$userId.jpg');
      final UploadTask uploadTask = ref.putFile(_imageFile!);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    _currentMedicationsController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  // Helper widget for section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
      ),
    );
  }

  // Helper widget for dropdown with checkmark
  Widget _buildDropdownWithCheck(String label, String? value, List<String> items, String hint) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  hint: Text(
                    hint,
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, color: Theme.of(context).textTheme.bodyMedium?.color, fontWeight: FontWeight.w500),
                  ),
                  icon: const SizedBox.shrink(),
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.w500),
                  dropdownColor: Theme.of(context).cardColor,
                  onChanged: (newValue) {
                    setState(() {
                      if (label == 'Blood Group') {
                        _selectedBloodGroup = newValue;
                      } else if (label == 'Marital Status') {
                        _selectedMaritalStatus = newValue;
                      }
                    });
                  },
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                child: Icon(Icons.check, color: Colors.white, size: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
    // 1. Required Fields Check
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter your Name'), backgroundColor: Colors.red));
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter your Phone Number'), backgroundColor: Colors.red));
      return;
    }
    if (_ageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter your Age'), backgroundColor: Colors.red));
      return;
    }

    // 2. Format Validations
    // Phone: Simple check for 10-15 digits
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(_phoneController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid Phone Number (10-15 digits)'), backgroundColor: Colors.red));
      return;
    }

    // Age: Numeric and reasonable range (0-120)
    final int? age = int.tryParse(_ageController.text.trim());
    if (age == null || age <= 0 || age > 120) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid Age (1-120)'), backgroundColor: Colors.red));
      return;
    }

    // Height: Numeric (cm)
    if (_heightController.text.isNotEmpty) {
      final double? height = double.tryParse(_heightController.text.trim());
      if (height == null || height <= 0 || height > 300) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid Height in cm'), backgroundColor: Colors.red));
        return;
      }
    }

    // Weight: Numeric (kg)
    if (_weightController.text.isNotEmpty) {
      final double? weight = double.tryParse(_weightController.text.trim());
      if (weight == null || weight <= 0 || weight > 500) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid Weight in kg'), backgroundColor: Colors.red));
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        // Upload image if selected
        String? imageUrl = await _uploadImage(user.uid);

        await _firestore.collection('users').doc(user.uid).update({'name': _nameController.text, 'email': _emailController.text, 'phone': _phoneController.text, 'age': _ageController.text, 'gender': _selectedGender, 'bloodGroup': _selectedBloodGroup, 'maritalStatus': _selectedMaritalStatus, 'address': _addressController.text, 'height': _heightController.text, 'weight': _weightController.text, 'allergies': _allergiesController.text, 'currentMedications': _currentMedicationsController.text, 'medicalHistory': _medicalHistoryController.text, 'emergencyContact': _emergencyContactController.text, 'profileComplete': true, 'updatedAt': FieldValue.serverTimestamp(), if (imageUrl != null) 'profileImageUrl': imageUrl});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile saved successfully!')));
          // Navigate to Home Screen (MainLayout)
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainLayoutScreen()), (Route<dynamic> route) => false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
            children: <Widget>[
              // Header Title
              Text(
                'Appointly',
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 34.0, fontWeight: FontWeight.bold, color: AppColors.madiBlue),
              ),
              const SizedBox(height: 10.0),

              // Create Profile subtitle
              RichText(
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 24.0, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Edit, ',
                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                    TextSpan(
                      text: 'Profile',
                      style: TextStyle(color: AppColors.madiBlue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),

              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.madiGrey.withValues(alpha: 0.2),
                      backgroundImage: _imageFile != null ? FileImage(_imageFile!) : (_profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null) as ImageProvider?,
                      child: (_imageFile == null && _profileImageUrl == null) ? Icon(Icons.person, size: 70, color: AppColors.madiGrey.withValues(alpha: 0.5)) : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.madiBlue, shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PERSONAL INFORMATION SECTION
              _buildSectionHeader('Personal Information'),

              // Full Name
              AppTextField(controller: _nameController, hintText: 'Full Name', keyboardType: TextInputType.name),
              const SizedBox(height: 16.0),

              // Email
              AppTextField(
                controller: _emailController,
                hintText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                readOnly: true, // Email usually shouldn't be editable easily
              ),
              const SizedBox(height: 16.0),

              // Phone Number
              AppTextField(controller: _phoneController, hintText: 'Phone Number', keyboardType: TextInputType.phone),
              const SizedBox(height: 16.0),

              // Age
              AppTextField(controller: _ageController, hintText: 'Age', keyboardType: TextInputType.number),
              const SizedBox(height: 24.0),

              // Gender Selection with Toggle Switches
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gender',
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 16.0, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  Row(
                    children: [
                      // Male Toggle
                      Text(
                        'Male',
                        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14.0, color: Theme.of(context).textTheme.bodyMedium?.color, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGender = 'Male';
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 28,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: _selectedGender == 'Male' ? AppColors.madiBlue.withValues(alpha: 0.2) : Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            alignment: _selectedGender == 'Male' ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: _selectedGender == 'Male' ? AppColors.madiBlue : Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      // Female Toggle
                      Text(
                        'Female',
                        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 14.0, color: Theme.of(context).textTheme.bodyMedium?.color, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGender = 'Female';
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 28,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: _selectedGender == 'Female' ? AppColors.madiBlue.withValues(alpha: 0.2) : Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            alignment: _selectedGender == 'Female' ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: _selectedGender == 'Female' ? AppColors.madiBlue : Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Blood Group Dropdown
              _buildDropdownWithCheck('Blood Group', _selectedBloodGroup, _bloodGroups, 'Select'),
              const SizedBox(height: 24.0),

              // Marital Status Dropdown
              _buildDropdownWithCheck('Marital Status', _selectedMaritalStatus, _maritalStatuses, 'Select'),
              const SizedBox(height: 16.0),

              // Address
              AppTextField(controller: _addressController, hintText: 'Complete Address', keyboardType: TextInputType.streetAddress),

              // MEDICAL INFORMATION SECTION
              _buildSectionHeader('Medical Information'),

              // Height
              Row(
                children: [
                  Expanded(
                    child: AppTextField(controller: _heightController, hintText: 'Height (cm)', keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: AppTextField(controller: _weightController, hintText: 'Weight (kg)', keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Allergies
              AppTextField(controller: _allergiesController, hintText: 'Known Allergies (if any)', keyboardType: TextInputType.multiline),
              const SizedBox(height: 16.0),

              // Current Medications
              AppTextField(controller: _currentMedicationsController, hintText: 'Current Medications (if any)', keyboardType: TextInputType.multiline),
              const SizedBox(height: 16.0),

              // Medical History
              AppTextField(controller: _medicalHistoryController, hintText: 'Past Medical History / Chronic Conditions', keyboardType: TextInputType.multiline),

              // EMERGENCY CONTACT SECTION
              _buildSectionHeader('Emergency Contact'),

              // Emergency Contact
              AppTextField(controller: _emergencyContactController, hintText: 'Emergency Contact (Name & Phone)', keyboardType: TextInputType.text),

              const SizedBox(height: 40.0),

              // Save Profile Button
              SizedBox(
                width: double.infinity,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.madiBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save Profile',
                    style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
