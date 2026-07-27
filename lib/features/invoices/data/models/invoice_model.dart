import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoify/features/clients/data/models/client_model.dart';
import 'package:invoify/features/invoices/data/models/invoice_item_model.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/discount_type.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';

class InvoiceModel {
  InvoiceModel({
    this.invoiceId = '',
    required this.invoiceNumber,
    required this.userId,
    required this.client,
    required this.items,
    DateTime? issueDate,
    DateTime? dueDate,
    required this.taxRate,
    required this.taxAmount,
    this.discountType = DiscountType.percentage,
    this.discountRate = 0.0,
    required this.discountAmount,
    required this.subtotal,
    required this.totalAmount,
    required this.status,
    required this.notes,
    DateTime? createdAt,
  })  : issueDate = issueDate ?? DateTime.now(),
        dueDate = dueDate ?? DateTime.now().add(const Duration(days: 14)),
        createdAt = createdAt ?? DateTime.now();

  factory InvoiceModel.fromJson(Map<String, dynamic> json, {String? docId}) =>
      InvoiceModel(
        invoiceId: docId ?? json['invoiceId'] ?? json['id'] ?? '',
        invoiceNumber: json['invoiceNumber'] ?? '',
        userId: json['userId'] ?? '',
        client: json['client'] != null
            ? ClientModel.fromJson(Map<String, dynamic>.from(json['client']))
            : ClientModel(
                clientId: '',
                userId: '',
                name: '',
                email: '',
                phone: '',
                address: '',
              ),
        items: json['items'] != null
            ? (json['items'] as List)
                .map(
                  (e) => InvoiceItemModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
            : [],
        issueDate: _parseTimestamp(json['issueDate']),
        dueDate: _parseTimestamp(json['dueDate']),
        taxRate: (json['taxRate'] as num?)?.toDouble() ?? 0.0,
        taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
        discountType: DiscountType.fromString(json['discountType']),
        discountRate: (json['discountRate'] as num?)?.toDouble() ?? 0.0,
        discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
        subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
        status: InvoiceStatus.fromString(json['status']),
        notes: json['notes'] ?? '',
        createdAt: _parseTimestamp(json['createdAt']),
      );

  factory InvoiceModel.fromEntity(InvoiceEntity entity) => InvoiceModel(
        invoiceId: entity.invoiceId,
        invoiceNumber: entity.invoiceNumber,
        userId: entity.userId,
        client: ClientModel.fromEntity(entity.client),
        items: entity.items.map((e) => InvoiceItemModel.fromEntity(e)).toList(),
        issueDate: entity.issueDate,
        dueDate: entity.dueDate,
        taxRate: entity.taxRate,
        taxAmount: entity.taxAmount,
        discountType: entity.discountType,
        discountRate: entity.discountRate,
        discountAmount: entity.discountAmount,
        subtotal: entity.subtotal,
        totalAmount: entity.totalAmount,
        status: entity.status,
        notes: entity.notes,
        createdAt: entity.createdAt,
      );

  final String invoiceId;
  final String invoiceNumber;
  final String userId;
  final ClientModel client;
  final List<InvoiceItemModel> items;
  final DateTime issueDate;
  final DateTime dueDate;
  final double taxRate;
  final double taxAmount;
  final DiscountType discountType;
  final double discountRate;
  final double discountAmount;
  final double subtotal;
  final double totalAmount;
  final InvoiceStatus status;
  final String notes;
  final DateTime createdAt;

  static DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  InvoiceModel copyWith({
    String? invoiceId,
    String? invoiceNumber,
    String? userId,
    ClientModel? client,
    List<InvoiceItemModel>? items,
    DateTime? issueDate,
    DateTime? dueDate,
    double? taxRate,
    double? taxAmount,
    DiscountType? discountType,
    double? discountRate,
    double? discountAmount,
    double? subtotal,
    double? totalAmount,
    InvoiceStatus? status,
    String? notes,
    DateTime? createdAt,
  }) =>
      InvoiceModel(
        invoiceId: invoiceId ?? this.invoiceId,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        userId: userId ?? this.userId,
        client: client ?? this.client,
        items: items ?? this.items,
        issueDate: issueDate ?? this.issueDate,
        dueDate: dueDate ?? this.dueDate,
        taxRate: taxRate ?? this.taxRate,
        taxAmount: taxAmount ?? this.taxAmount,
        discountType: discountType ?? this.discountType,
        discountRate: discountRate ?? this.discountRate,
        discountAmount: discountAmount ?? this.discountAmount,
        subtotal: subtotal ?? this.subtotal,
        totalAmount: totalAmount ?? this.totalAmount,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toJson() => {
        'invoiceId': invoiceId,
        'invoiceNumber': invoiceNumber,
        'userId': userId,
        'client': client.toJson(),
        'items': items.map((e) => e.toJson()).toList(),
        'issueDate': Timestamp.fromDate(issueDate),
        'dueDate': Timestamp.fromDate(dueDate),
        'taxRate': taxRate,
        'taxAmount': taxAmount,
        'discountType': discountType.name,
        'discountRate': discountRate,
        'discountAmount': discountAmount,
        'subtotal': subtotal,
        'totalAmount': totalAmount,
        'status': status.name,
        'notes': notes,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  InvoiceEntity toEntity() => InvoiceEntity(
        invoiceId: invoiceId,
        invoiceNumber: invoiceNumber,
        userId: userId,
        client: client.toEntity(),
        items: items.map((e) => e.toEntity()).toList(),
        issueDate: issueDate,
        dueDate: dueDate,
        taxRate: taxRate,
        taxAmount: taxAmount,
        discountType: discountType,
        discountRate: discountRate,
        discountAmount: discountAmount,
        subtotal: subtotal,
        totalAmount: totalAmount,
        status: status,
        notes: notes,
        createdAt: createdAt,
      );
}
