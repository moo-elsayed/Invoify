import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_metrics_cards.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_recent_invoices.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_revenue_chart.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_status_chart.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DashboardSkeletonLoading extends StatelessWidget {
  const DashboardSkeletonLoading({super.key});

  static final List<InvoiceEntity> _dummyInvoices = List.generate(
    3,
    (index) => InvoiceEntity(
      invoiceId: 'dummy_$index',
      invoiceNumber: 'INV-20260726-000$index',
      client: const ClientEntity(name: 'Client Name Placeholder'),
      subtotal: 1000.0,
      totalAmount: 1140.0,
      status: InvoiceStatus.paid,
      createdAt: DateTime.now(),
    ),
  );

  static const Map<int, double> _dummyRevenueMap = {
    0: 1200.0,
    1: 2500.0,
    2: 1800.0,
    3: 3200.0,
    4: 2100.0,
    5: 4500.0,
  };

  static const Map<InvoiceStatus, int> _dummyStatusDist = {
    InvoiceStatus.paid: 5,
    InvoiceStatus.sent: 3,
    InvoiceStatus.overdue: 2,
    InvoiceStatus.draft: 1,
  };

  @override
  Widget build(BuildContext context) => Skeletonizer(
    enabled: true,
    child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 80.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardMetricsCards(
            monthlyEarnings: 12500.0,
            totalOverdue: 3400.0,
            pendingAmount: 2100.0,
            activeClientsCount: 15,
          ),
          Gap(16.h),
          const DashboardRevenueChart(monthlyRevenueMap: _dummyRevenueMap),
          Gap(16.h),
          const DashboardStatusChart(statusDistribution: _dummyStatusDist),
          Gap(16.h),
          DashboardRecentInvoices(recentInvoices: _dummyInvoices),
        ],
      ),
    ),
  );
}
