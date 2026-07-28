import 'package:equatable/equatable.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardSuccess extends DashboardState {
  const DashboardSuccess({
    required this.monthlyEarnings,
    required this.totalOverdue,
    required this.pendingAmount,
    required this.totalClientsCount,
    required this.monthlyRevenueMap,
    required this.statusDistribution,
    required this.recentInvoices,
  });

  final double monthlyEarnings;
  final double totalOverdue;
  final double pendingAmount;
  final int totalClientsCount;
  final Map<int, double> monthlyRevenueMap;
  final Map<InvoiceStatus, int> statusDistribution;
  final List<InvoiceEntity> recentInvoices;

  @override
  List<Object?> get props => [
        monthlyEarnings,
        totalOverdue,
        pendingAmount,
        totalClientsCount,
        monthlyRevenueMap,
        statusDistribution,
        recentInvoices,
      ];
}

final class DashboardFailure extends DashboardState {
  const DashboardFailure(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
