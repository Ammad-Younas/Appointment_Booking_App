// lib/src/services/doctor_service.dart
import 'package:flutter/material.dart';

// You can expand this model as needed
class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final int price;
  final int slots;
  final String image;
  // Add more details for the details screen
  final String about;
  final String qualification;
  final String location;

  Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.price,
    required this.slots,
    required this.image,
    required this.about,
    required this.qualification,
    required this.location,
  });

  // Convert to a Map for easy passing between screens
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'price': price,
      'slots': slots,
      'image': image,
      'about': about,
      'qualification': qualification,
      'location': location,
    };
  }
}

class DoctorService {
  // This is your single source of truth for all doctors
  static final List<Doctor> _allDoctors = [
    Doctor(
      name: 'Dr. Assad Abbas',
      specialty: 'Nerologist',
      rating: 4.5,
      price: 28,
      slots: 5,
      image: 'assets/images/doctor_1.png',
      about: 'Dr. Assad Abbas is a highly experienced Nerologist with over 10 years of practice. They are dedicated to providing the best patient care.',
      qualification: '1. Medical Degree from Metropolis University.\n2. Board Certified in Neurology.',
      location: 'City Hospital, 123 Health St, Suite 405, Metropolis, USA',
    ),
    Doctor(
      name: 'Dr. Kamran',
      specialty: 'Dentist',
      rating: 4.3,
      price: 25,
      slots: 5,
      image: 'assets/images/doctor_2.png',
      about: 'Dr. Kamran is a skilled Dentist known for a gentle touch and excellent patient outcomes. 12 years of experience.',
      qualification: '1. DDS from Metropolis Dental School.\n2. Member of the National Dental Association.',
      location: 'Downtown Dental, 456 Main St, Metropolis, USA',
    ),
    Doctor(
      name: 'Dr. Aliyah Khan',
      specialty: 'Nerologist',
      rating: 4.8,
      price: 35,
      slots: 3,
      image: 'assets/images/doctor_female.png', // You need to add this image
      about: 'Dr. Aliyah Khan specializes in complex neurological disorders and is a leader in the field of brain health.',
      qualification: '1. MD, PhD from Central City University.\n2. Chief of Neurology at City Hospital.',
      location: 'City Hospital, 123 Health St, Suite 405, Metropolis, USA',
    ),
    Doctor(
      name: 'Dr. Farhan Ahmed',
      specialty: 'Cardiologist',
      rating: 4.7,
      price: 40,
      slots: 2,
      image: 'assets/images/doctor_male2.png', // You need to add this image
      about: 'Dr. Farhan Ahmed is a board-certified Cardiologist focused on preventative care and advanced heart treatments.',
      qualification: '1. MD from Starling City University.\n2. Fellow of the American College of Cardiology.',
      location: 'Metropolis Heart Institute, 789 Park Ave, Metropolis, USA',
    ),
    Doctor(
      name: 'Dr. Sara Ali',
      specialty: 'Dentist',
      rating: 4.6,
      price: 30,
      slots: 8,
      image: 'assets/images/doctor_female2.png', // You need to add this image
      about: 'Dr. Sara Ali provides comprehensive dental care for the whole family, from routine checkups to advanced cosmetic dentistry.',
      qualification: '1. DMD from Metropolis Dental School.\n2. Certified in Pediatric Dentistry.',
      location: 'Family Dental Care, 101 Suburb St, Metropolis, USA',
    ),
  ];

  // Get all doctors
  static List<Doctor> getAllDoctors() {
    return _allDoctors;
  }

  // Get doctors by category
  static List<Doctor> getDoctorsByCategory(String category) {
    return _allDoctors.where((doctor) => doctor.specialty == category).toList();
  }

  // Get just the top-rated doctors for the home screen
  static List<Doctor> getTopDoctors() {
    // For this example, we'll just take the first 3
    // You could sort by rating in a real app
    return _allDoctors.take(3).toList();
  }
}