import 'package:equatable/equatable.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_item_entity.dart';
import 'package:invoify/features/invoices/domain/enums/discount_type.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';

class InvoiceEntity extends Equatable {
  const InvoiceEntity({
    this.invoiceId = '',
    this.invoiceNumber = '',
    this.userId = '',
    this.client = const ClientEntity(),
    this.items = const [],
    this.issueDate,
    this.dueDate,
    this.taxRate = 0.0,
    this.taxAmount = 0.0,
    this.discountType = DiscountType.percentage,
    this.discountRate = 0.0,
    this.discountAmount = 0.0,
    this.subtotal = 0.0,
    this.totalAmount = 0.0,
    this.status = InvoiceStatus.draft,
    this.notes = '',
    this.createdAt,
    this.paidAt,
  });

  final String invoiceId;
  final String invoiceNumber;
  final String userId;
  final ClientEntity client;
  final List<InvoiceItemEntity> items;
  final DateTime? issueDate;
  final DateTime? dueDate;
  final double taxRate;
  final double taxAmount;
  final DiscountType discountType;
  final double discountRate;
  final double discountAmount;
  final double subtotal;
  final double totalAmount;
  final InvoiceStatus status;
  final String notes;
  final DateTime? createdAt;
  final DateTime? paidAt;

  @override
  List<Object?> get props => [
        invoiceId,
        invoiceNumber,
        userId,
        client,
        items,
        issueDate,
        dueDate,
        taxRate,
        taxAmount,
        discountType,
        discountRate,
        discountAmount,
        subtotal,
        totalAmount,
        status,
        notes,
        createdAt,
        paidAt,
      ];

  InvoiceEntity copyWith({
    String? invoiceId,
    String? invoiceNumber,
    String? userId,
    ClientEntity? client,
    List<InvoiceItemEntity>? items,
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
    DateTime? paidAt,
  }) =>
      InvoiceEntity(
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
        paidAt: paidAt ?? this.paidAt,
      );
}
