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
    return {'id': id, 'name': name, 'specialty': specialty, 'rating': rating, 'price': price, 'slots': slots, 'image': image, 'about': about, 'qualification': qualification, 'location': location};
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
}
