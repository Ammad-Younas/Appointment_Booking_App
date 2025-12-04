import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int price;
  final int slots;
  final String image;
  final String about;
  final String qualification;
  final String location;

  Doctor({required this.id, required this.name, required this.specialty, required this.rating, required this.price, required this.slots, required this.image, required this.about, required this.qualification, required this.location});

  factory Doctor.fromMap(Map<String, dynamic> map, String id) {
    return Doctor(
      id: id,
      name: map['name'] ?? 'Unknown Doctor',
      specialty: map['specialty'] ?? 'Specialist',
      rating: (map['rating'] is String ? double.tryParse(map['rating']) : (map['rating'] as num?)?.toDouble()) ?? 0.0,
      price: (map['price'] is String ? int.tryParse(map['price']) : (map['price'] as num?)?.toInt()) ?? 100,
      slots: (map['slots'] is String ? int.tryParse(map['slots']) : (map['slots'] as num?)?.toInt()) ?? 10,
      image: map['image'] ?? map['imageUrl'] ?? '', // Handle both image and imageUrl
      about: map['about'] ?? 'No details available.',
      qualification: map['qualification'] ?? 'MBBS', // Default qualification
      location: map['location'] ?? map['hospital'] ?? 'City Hospital', // Use hospital as fallback for location
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'specialty': specialty, 'rating': rating, 'price': price, 'slots': slots, 'image': image, 'about': about, 'qualification': qualification, 'location': location};
  }
}

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all doctors
  Stream<List<Doctor>> getDoctors() {
    return _firestore.collection('doctors').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Doctor.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get doctors by category
  Stream<List<Doctor>> getDoctorsByCategory(String category) {
    return _firestore.collection('doctors').where('specialty', isEqualTo: category).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Doctor.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get top doctors (for home screen)
  Stream<List<Doctor>> getTopDoctors() {
    return _firestore.collection('doctors').orderBy('rating', descending: true).limit(5).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Doctor.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Seed initial data (Run this once if needed)
  Future<void> seedDoctors() async {
    final List<Map<String, dynamic>> initialDoctors = [
      {'name': 'Dr. Assad Abbas', 'specialty': 'Nerologist', 'rating': 4.5, 'price': 28, 'slots': 5, 'image': 'https://randomuser.me/api/portraits/men/32.jpg', 'about': 'Dr. Assad Abbas is a highly experienced Nerologist with over 10 years of practice.', 'qualification': '1. Medical Degree from Metropolis University.\n2. Board Certified in Neurology.', 'location': 'City Hospital, 123 Health St, Suite 405, Metropolis, USA'},
      {'name': 'Dr. Kamran', 'specialty': 'Dentist', 'rating': 4.3, 'price': 25, 'slots': 5, 'image': 'https://randomuser.me/api/portraits/men/45.jpg', 'about': 'Dr. Kamran is a skilled Dentist known for a gentle touch and excellent patient outcomes.', 'qualification': '1. DDS from Metropolis Dental School.\n2. Member of the National Dental Association.', 'location': 'Downtown Dental, 456 Main St, Metropolis, USA'},
      {'name': 'Dr. Aliyah Khan', 'specialty': 'Nerologist', 'rating': 4.8, 'price': 35, 'slots': 3, 'image': 'https://randomuser.me/api/portraits/women/44.jpg', 'about': 'Dr. Aliyah Khan specializes in complex neurological disorders.', 'qualification': '1. MD, PhD from Central City University.\n2. Chief of Neurology at City Hospital.', 'location': 'City Hospital, 123 Health St, Suite 405, Metropolis, USA'},
      {'name': 'Dr. Farhan Ahmed', 'specialty': 'Cardiologist', 'rating': 4.7, 'price': 40, 'slots': 2, 'image': 'https://randomuser.me/api/portraits/men/22.jpg', 'about': 'Dr. Farhan Ahmed is a board-certified Cardiologist focused on preventative care.', 'qualification': '1. MD from Starling City University.\n2. Fellow of the American College of Cardiology.', 'location': 'Metropolis Heart Institute, 789 Park Ave, Metropolis, USA'},
      {'name': 'Dr. Sara Ali', 'specialty': 'Dentist', 'rating': 4.6, 'price': 30, 'slots': 8, 'image': 'https://randomuser.me/api/portraits/women/68.jpg', 'about': 'Dr. Sara Ali provides comprehensive dental care for the whole family.', 'qualification': '1. DMD from Metropolis Dental School.\n2. Certified in Pediatric Dentistry.', 'location': 'Family Dental Care, 101 Suburb St, Metropolis, USA'},
    ];

    for (var doctor in initialDoctors) {
      await _firestore.collection('doctors').add(doctor);
    }
  }
}
