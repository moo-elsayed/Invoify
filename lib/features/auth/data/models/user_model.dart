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
    this.fcmToken,
    this.languageCode = 'ar',
    this.lastTokenUpdate,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromFirebaseUser(
    User user, {
    String? businessName,
    String? currency,
    String? fcmToken,
    String? languageCode,
    DateTime? lastTokenUpdate,
  }) => UserModel(
    uid: user.uid,
    businessName: businessName ?? user.displayName ?? '',
    email: user.email ?? '',
    currency: currency ?? 'EGP',
    createdAt: DateTime.now(),
    isVerified: user.emailVerified,
    fcmToken: fcmToken,
    languageCode: languageCode ?? 'ar',
    lastTokenUpdate: lastTokenUpdate,
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
    fcmToken: map['fcmToken'] as String?,
    languageCode: map['languageCode'] as String? ?? 'ar',
    lastTokenUpdate: map['lastTokenUpdate'] != null
        ? (map['lastTokenUpdate'] is Timestamp
              ? (map['lastTokenUpdate'] as Timestamp).toDate()
              : DateTime.tryParse(map['lastTokenUpdate'].toString()))
        : null,
  );

  factory UserModel.fromUserEntity(UserEntity user) => UserModel(
    uid: user.uid,
    businessName: user.businessName,
    email: user.email,
    currency: user.currency,
    createdAt: user.createdAt,
    isVerified: user.isVerified,
    fcmToken: user.fcmToken,
    languageCode: user.languageCode,
    lastTokenUpdate: user.lastTokenUpdate,
  );

  final String uid;
  String businessName;
  final String email;
  final String currency;
  final DateTime createdAt;
  final bool isVerified;
  final String? fcmToken;
  final String languageCode;
  final DateTime? lastTokenUpdate;

  Map<String, dynamic> toJson() => {
    'userId': uid,
    'businessName': businessName,
    'email': email,
    'currency': currency,
    'createdAt': Timestamp.fromDate(createdAt),
    'isVerified': isVerified,
    if (fcmToken != null) 'fcmToken': fcmToken,
    'languageCode': languageCode,
    if (lastTokenUpdate != null)
      'lastTokenUpdate': Timestamp.fromDate(lastTokenUpdate!),
  };

  Map<String, dynamic> toLocalJson() => {
    'userId': uid,
    'businessName': businessName,
    'email': email,
    'currency': currency,
    'createdAt': createdAt.toIso8601String(),
    'isVerified': isVerified,
    if (fcmToken != null) 'fcmToken': fcmToken,
    'languageCode': languageCode,
    if (lastTokenUpdate != null)
      'lastTokenUpdate': lastTokenUpdate!.toIso8601String(),
  };

  UserEntity toUserEntity() => UserEntity(
    uid: uid,
    businessName: businessName,
    email: email,
    currency: currency,
    createdAt: createdAt,
    isVerified: isVerified,
    fcmToken: fcmToken,
    languageCode: languageCode,
    lastTokenUpdate: lastTokenUpdate,
  );
}
