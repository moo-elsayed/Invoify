import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    this.uid = '',
    this.businessName = '',
    this.email = '',
    this.currency = 'USD',
    this.createdAt,
    this.isVerified = false,
  });

  final String uid;
  final String businessName;
  final String email;
  final String currency;
  final DateTime? createdAt;
  final bool isVerified;

  String get name => businessName;

  @override
  List<Object?> get props => [
        uid,
        businessName,
        email,
        currency,
        createdAt,
        isVerified,
      ];

  UserEntity copyWith({
    String? uid,
    String? businessName,
    String? email,
    String? currency,
    DateTime? createdAt,
    bool? isVerified,
  }) =>
      UserEntity(
        uid: uid ?? this.uid,
        businessName: businessName ?? this.businessName,
        email: email ?? this.email,
        currency: currency ?? this.currency,
        createdAt: createdAt ?? this.createdAt,
        isVerified: isVerified ?? this.isVerified,
      );
}
