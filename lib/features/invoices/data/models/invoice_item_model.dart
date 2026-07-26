import 'package:invoify/features/invoices/domain/entities/invoice_item_entity.dart';

class InvoiceItemModel {
  InvoiceItemModel({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      InvoiceItemModel(
        itemId: json['itemId'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
        unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      );

  factory InvoiceItemModel.fromEntity(InvoiceItemEntity entity) =>
      InvoiceItemModel(
        itemId: entity.itemId,
        name: entity.name,
        quantity: entity.quantity,
        unitPrice: entity.unitPrice,
      );

  final String itemId;
  final String name;
  final double quantity;
  final double unitPrice;

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'name': name,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'totalPrice': quantity * unitPrice,
  };

  InvoiceItemEntity toEntity() => InvoiceItemEntity(
    itemId: itemId,
    name: name,
    quantity: quantity,
    unitPrice: unitPrice,
  );
}
