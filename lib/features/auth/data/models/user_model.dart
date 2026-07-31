import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';

class UserModel {
  UserModel({
    required this.uid,
    required this.businessName,
    required this.email,
    this.currency = 'EGP',
    DateTime? createdAt,
    this.isVerified = false,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromFirebaseUser(
    User user, {
    String? businessName,
    String? currency,
  }) =>
      UserModel(
        uid: user.uid,
        businessName: businessName ?? user.displayName ?? '',
        email: user.email ?? '',
        currency: currency ?? 'EGP',
        createdAt: DateTime.now(),
        isVerified: user.emailVerified,
      );

  factory UserModel.fromJson(Map<String, dynamic> map) => UserModel(
        uid: map['userId'] ?? map['uid'] ?? '',
        businessName: map['businessName'] ?? map['name'] ?? '',
        email: map['email'] ?? '',
        currency: map['currency'] ?? 'EGP',
        createdAt: map['createdAt'] != null
            ? (map['createdAt'] is Timestamp
                ? (map['createdAt'] as Timestamp).toDate()
                : DateTime.tryParse(map['createdAt'].toString()) ??
                    DateTime.now())
            : DateTime.now(),
        isVerified: map['isVerified'] ?? false,
      );

  factory UserModel.fromUserEntity(UserEntity user) => UserModel(
        uid: user.uid,
        businessName: user.businessName,
        email: user.email,
        currency: user.currency,
        createdAt: user.createdAt,
        isVerified: user.isVerified,
      );

  final String uid;
  String businessName;
  final String email;
  final String currency;
  final DateTime createdAt;
  final bool isVerified;

  Map<String, dynamic> toJson() => {
        'userId': uid,
        'businessName': businessName,
        'email': email,
        'currency': currency,
        'createdAt': Timestamp.fromDate(createdAt),
        'isVerified': isVerified,
      };

  UserEntity toUserEntity() => UserEntity(
        uid: uid,
        businessName: businessName,
        email: email,
        currency: currency,
        createdAt: createdAt,
        isVerified: isVerified,
      );
}
