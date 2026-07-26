import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'invoice_card.dart';

class InvoiceSkeletonList extends StatelessWidget {
  const InvoiceSkeletonList({super.key});

  static final List<InvoiceEntity> _dummyInvoices = List.generate(
    4,
    (index) => InvoiceEntity(
      invoiceId: 'dummy_$index',
      invoiceNumber: 'INV-20260726-000$index',
      client: const ClientEntity(name: 'Client Name Placeholder'),
      subtotal: 1000.0,
      totalAmount: 1140.0,
      status: InvoiceStatus.draft,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 14)),
    ),
  );

  @override
  Widget build(BuildContext context) => Skeletonizer(
    enabled: true,
    child: ListView.separated(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 90.h),
      itemCount: _dummyInvoices.length,
      separatorBuilder: (context, index) => Gap(12.h),
      itemBuilder: (context, index) => InvoiceCard(
        invoice: _dummyInvoices[index],
        onDelete: () {},
        onStatusChanged: (status) {},
      ),
    ),
  );
}
