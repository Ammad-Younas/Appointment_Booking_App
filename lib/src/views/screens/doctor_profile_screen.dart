import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:appointment_booking_app/utils/app_colors.dart';
import 'package:appointment_booking_app/src/views/widgets/app_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _nameController = TextEditingController();
  // Specialty managed by dropdown
  final _aboutController = TextEditingController();
  final _priceController = TextEditingController();
  final _experienceController = TextEditingController();
  final _locationController = TextEditingController();
  final _slotsController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  File? _imageFile;
  String? _profileImageUrl;

  // Predefined specialties
  final List<String> _specialties = ['Cardiologist', 'Dentist', 'Dermatologist', 'Neurologist', 'Orthopedic', 'Pediatrician', 'Psychiatrist', 'Surgeon', 'General Physician'];
  String? _selectedSpecialty;

  @override
  void initState() {
    super.initState();
    _fetchDoctorData();
  }

  Future<void> _fetchDoctorData() async {
    setState(() => _isLoading = true);
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        // Try fetching from doctors collection first
        final doc = await _firestore.collection('doctors').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          _nameController.text = data['name'] ?? '';
          _selectedSpecialty = data['specialty'];
          _aboutController.text = data['about'] ?? '';
          _priceController.text = (data['price'] ?? 100).toString();
          _slotsController.text = (data['slots'] ?? 10).toString();
          _experienceController.text = data['experience'] ?? '';
          _locationController.text = data['location'] ?? '';
          _profileImageUrl = data['image']; // Note: field name in Doctor model is 'image'
        } else {
          // If not in doctors, check users for basic info
          final userDoc = await _firestore.collection('users').doc(user.uid).get();
          if (userDoc.exists) {
            final userData = userDoc.data()!;
            _nameController.text = userData['name'] ?? '';
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching doctor data: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<String?> _uploadImage(String userId) async {
    if (_imageFile == null) return _profileImageUrl;
    try {
      final Reference ref = _storage.ref().child('doctor_profiles').child('$userId.jpg');
      await ref.putFile(_imageFile!);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveProfile() async {
    // 1. Required Fields Check
    String? errorMessage;
    if (_nameController.text.trim().isEmpty) {
      errorMessage = 'Please enter your Name';
    } else if (_selectedSpecialty == null) {
      errorMessage = 'Please select a Specialty';
    } else {
      // 2. Numeric Validations
      final int? price = int.tryParse(_priceController.text.trim());
      if (price == null || price <= 0) {
        errorMessage = 'Please enter a valid Price (greater than 0)';
      } else {
        final int? slots = int.tryParse(_slotsController.text.trim());
        if (slots == null || slots < 0) {
          errorMessage = 'Please enter a valid number of Slots';
        }
      }
    }

    if (errorMessage != null) {
      _showErrorDialog(errorMessage);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        String? imageUrl = await _uploadImage(user.uid);

        // Data to save
        final doctorData = {
          'id': user.uid,
          'name': _nameController.text.trim(),
          'specialty': _selectedSpecialty,
          'about': _aboutController.text.trim(),
          'price': int.tryParse(_priceController.text.trim()) ?? 100,
          'rating': 4.5, // Default/Placeholder rating
          'slots': int.tryParse(_slotsController.text.trim()) ?? 10,
          'qualification': _experienceController.text.trim(),
          'location': _locationController.text.trim(),
          'image': imageUrl ?? '',
          'updatedAt': FieldValue.serverTimestamp(),
        };

        // 1. Save to 'doctors' collection (Public Profile)
        await _firestore.collection('doctors').doc(user.uid).set(doctorData, SetOptions(merge: true));

        // 2. Update 'users' collection (Private Profile role data)
        await _firestore.collection('users').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'profileComplete': true,
          'role': 'doctor', // Ensure role remains doctor
        }, SetOptions(merge: true));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile saved successfully!')));
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      _showErrorDialog('Error saving profile: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invalid Input'),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
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
          title: Text('Edit Doctor Profile', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(radius: 50, backgroundImage: _imageFile != null ? FileImage(_imageFile!) : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty ? NetworkImage(_profileImageUrl!) : null) as ImageProvider?, child: (_imageFile == null && (_profileImageUrl == null || _profileImageUrl!.isEmpty)) ? Icon(Icons.add_a_photo, size: 30) : null),
                    ),
                    SizedBox(height: 20),
                    AppTextField(controller: _nameController, hintText: 'Full Name'),
                    SizedBox(height: 16),
                    // Specialty Dropdown
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text("Select Specialty"),
                          value: _selectedSpecialty,
                          items: _specialties.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                          onChanged: (v) => setState(() => _selectedSpecialty = v),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    AppTextField(controller: _priceController, hintText: 'Consultation Price (e.g. 50)', keyboardType: TextInputType.number),
                    SizedBox(height: 16),
                    AppTextField(controller: _slotsController, hintText: 'Available Slots (e.g. 15)', keyboardType: TextInputType.number),
                    SizedBox(height: 16),
                    AppTextField(controller: _experienceController, hintText: 'Qualification / Experience'),
                    SizedBox(height: 16),
                    AppTextField(controller: _locationController, hintText: 'Hospital / Clinic Location'),
                    SizedBox(height: 16),
                    AppTextField(controller: _aboutController, hintText: 'About / Bio', keyboardType: TextInputType.multiline),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.madiBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text(
                          'Save Public Profile',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
