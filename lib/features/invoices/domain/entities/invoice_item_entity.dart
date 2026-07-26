import 'package:equatable/equatable.dart';

class InvoiceItemEntity extends Equatable {
  const InvoiceItemEntity({
    this.itemId = '',
    this.name = '',
    this.quantity = 1,
    this.unitPrice = 0.0,
  });

  final String itemId;
  final String name;
  final double quantity;
  final double unitPrice;

  double get totalPrice => quantity * unitPrice;

  @override
  List<Object?> get props => [itemId, name, quantity, unitPrice];

  InvoiceItemEntity copyWith({
    String? itemId,
    String? name,
    double? quantity,
    double? unitPrice,
  }) =>
      InvoiceItemEntity(
        itemId: itemId ?? this.itemId,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
      );
}
