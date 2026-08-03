import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    this.uid = '',
    this.businessName = '',
    this.email = '',
    this.currency = 'EGP',
    this.createdAt,
    this.isVerified = false,
    this.fcmToken,
    this.languageCode = 'ar',
    this.lastTokenUpdate,
  });

  final String uid;
  final String businessName;
  final String email;
  final String currency;
  final DateTime? createdAt;
  final bool isVerified;
  final String? fcmToken;
  final String languageCode;
  final DateTime? lastTokenUpdate;

  String get displayName {
    if (businessName.trim().isNotEmpty) {
      return businessName;
    }
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return email;
  }

  @override
  List<Object?> get props => [
    uid,
    businessName,
    email,
    currency,
    createdAt,
    isVerified,
    fcmToken,
    languageCode,
    lastTokenUpdate,
  ];

  UserEntity copyWith({
    String? uid,
    String? businessName,
    String? email,
    String? currency,
    DateTime? createdAt,
    bool? isVerified,
    String? fcmToken,
    String? languageCode,
    DateTime? lastTokenUpdate,
  }) => UserEntity(
    uid: uid ?? this.uid,
    businessName: businessName ?? this.businessName,
    email: email ?? this.email,
    currency: currency ?? this.currency,
    createdAt: createdAt ?? this.createdAt,
    isVerified: isVerified ?? this.isVerified,
    fcmToken: fcmToken ?? this.fcmToken,
    languageCode: languageCode ?? this.languageCode,
    lastTokenUpdate: lastTokenUpdate ?? this.lastTokenUpdate,
  );
}
