import 'package:equatable/equatable.dart';

class ClientEntity extends Equatable {
  const ClientEntity({
    this.clientId = '',
    this.userId = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.createdAt,
  });

  final String clientId;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
    clientId,
    userId,
    name,
    email,
    phone,
    address,
    createdAt,
  ];

  ClientEntity copyWith({
    String? clientId,
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? createdAt,
  }) => ClientEntity(
    clientId: clientId ?? this.clientId,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    createdAt: createdAt ?? this.createdAt,
  );
}
