import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Add this line

class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String? profileImage;
  final String role;
  final DateTime createdAt;
  final String? address;
  final double? latitude;
  final double? longitude;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.profileImage,
    this.role = 'customer',
    required this.createdAt,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      role: json['role'] ?? 'customer',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profileImage': profileImage,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}