import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? dateOfBirth;
  final double? weight;
  final double? height;
  final String? goal;
  final String? photoUrl; // Nouveau champ pour l'URL de la photo
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.weight,
    this.height,
    this.goal,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
  });

  // Convertir l'objet en map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'weight': weight,
      'height': height,
      'goal': goal,
      'photoUrl': photoUrl,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Créer un UserModel à partir d'un document Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'],
      weight: (map['weight'] as num?)?.toDouble(),
      height: (map['height'] as num?)?.toDouble(),
      goal: map['goal'],
      photoUrl: map['photoUrl'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Copier l'objet avec des modifications
  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? dateOfBirth,
    double? weight,
    double? height,
    String? goal,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      goal: goal ?? this.goal,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}