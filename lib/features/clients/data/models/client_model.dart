import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';

class ClientModel {
  ClientModel({
    required this.clientId,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ClientModel.fromJson(Map<String, dynamic> map, {String? docId}) =>
      ClientModel(
        clientId: docId ?? map['clientId'] ?? map['id'] ?? '',
        userId: map['userId'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        phone: map['phone'] ?? '',
        address: map['address'] ?? '',
        createdAt: map['createdAt'] != null
            ? (map['createdAt'] is Timestamp
                ? (map['createdAt'] as Timestamp).toDate()
                : DateTime.tryParse(map['createdAt'].toString()) ??
                    DateTime.now())
            : DateTime.now(),
      );

  factory ClientModel.fromEntity(ClientEntity entity) => ClientModel(
        clientId: entity.clientId,
        userId: entity.userId,
        name: entity.name,
        email: entity.email,
        phone: entity.phone,
        address: entity.address,
        createdAt: entity.createdAt,
      );

  final String clientId;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'clientId': clientId,
        'userId': userId,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  ClientEntity toEntity() => ClientEntity(
        clientId: clientId,
        userId: userId,
        name: name,
        email: email,
        phone: phone,
        address: address,
        createdAt: createdAt,
      );
}
