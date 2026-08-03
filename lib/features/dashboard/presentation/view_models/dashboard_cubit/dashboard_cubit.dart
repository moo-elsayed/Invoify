import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/domain/use_cases/get_clients_use_case.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/domain/use_cases/get_invoices_use_case.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(
    this._getInvoicesUseCase,
    this._getClientsUseCase, {
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       super(const DashboardInitial());

  final GetInvoicesUseCase _getInvoicesUseCase;
  final GetClientsUseCase _getClientsUseCase;
  final FirebaseAuth _firebaseAuth;

  List<InvoiceEntity> _cachedInvoices = [];
  int _cachedClientsCount = 0;

  Future<void> loadDashboardData({bool forceRefresh = false}) async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return;

    if (!forceRefresh && state is DashboardSuccess) {
      return;
    }

    emit(const DashboardLoading());

    final invoiceResult = await _getInvoicesUseCase(firebaseUser.uid);
    final clientResult = await _getClientsUseCase(firebaseUser.uid);

    List<InvoiceEntity> invoices = [];
    switch (invoiceResult) {
      case NetworkSuccess<List<InvoiceEntity>>():
        invoices = invoiceResult.data ?? [];
      case NetworkFailure<List<InvoiceEntity>>():
        emit(DashboardFailure(invoiceResult.error));
        return;
    }

    int clientsCount = 0;
    switch (clientResult) {
      case NetworkSuccess<List<ClientEntity>>():
        clientsCount = (clientResult.data ?? []).length;
      case NetworkFailure<List<ClientEntity>>():
        emit(DashboardFailure(clientResult.error));
        return;
    }

    _cachedInvoices = invoices;
    _cachedClientsCount = clientsCount;

    _processAndEmitDashboardData(_cachedInvoices, _cachedClientsCount);
  }

  void updateFromInvoices(List<InvoiceEntity> invoices) {
    _cachedInvoices = invoices;
    _processAndEmitDashboardData(_cachedInvoices, _cachedClientsCount);
  }

  void updateClientsCount(int clientsCount) {
    _cachedClientsCount = clientsCount;
    _processAndEmitDashboardData(_cachedInvoices, _cachedClientsCount);
  }

  // private method to process and emit dashboard data
  void _processAndEmitDashboardData(
    List<InvoiceEntity> invoices,
    int clientsCount,
  ) {
    final now = DateTime.now();

    double monthlyEarnings = 0.0;
    double totalOverdue = 0.0;
    double pendingAmount = 0.0;

    final Map<InvoiceStatus, int> statusDist = {
      InvoiceStatus.paid: 0,
      InvoiceStatus.sent: 0,
      InvoiceStatus.opened: 0,
      InvoiceStatus.overdue: 0,
      InvoiceStatus.draft: 0,
      InvoiceStatus.cancelled: 0,
    };

    final Map<int, double> monthlyRev = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (final inv in invoices) {
      statusDist[inv.status] = (statusDist[inv.status] ?? 0) + 1;

      if (inv.status == InvoiceStatus.overdue) {
        totalOverdue += inv.totalAmount;
      } else if (inv.status == InvoiceStatus.sent ||
          inv.status == InvoiceStatus.opened) {
        pendingAmount += inv.totalAmount;
      } else if (inv.status == InvoiceStatus.paid) {
        final paymentDate = inv.paidAt ?? inv.createdAt ?? DateTime.now();
        if (paymentDate.year == now.year && paymentDate.month == now.month) {
          monthlyEarnings += inv.totalAmount;
        }

        // Calculate revenue trends for past 6 months (0 to 5) based on actual payment date (paidAt)
        final monthDiff =
            (now.year - paymentDate.year) * 12 +
            (now.month - paymentDate.month);
        if (monthDiff >= 0 && monthDiff < 6) {
          final barIndex = 5 - monthDiff;
          monthlyRev[barIndex] = (monthlyRev[barIndex] ?? 0) + inv.totalAmount;
        }
      }
    }

    final sortedInvoices = List<InvoiceEntity>.from(invoices)
      ..sort((a, b) {
        final dateA = a.createdAt ?? DateTime.now();
        final dateB = b.createdAt ?? DateTime.now();
        return dateB.compareTo(dateA);
      });

    final recentInvoices = sortedInvoices.take(3).toList();

    emit(
      DashboardSuccess(
        monthlyEarnings: monthlyEarnings,
        totalOverdue: totalOverdue,
        pendingAmount: pendingAmount,
        totalClientsCount: clientsCount,
        monthlyRevenueMap: monthlyRev,
        statusDistribution: statusDist,
        recentInvoices: recentInvoices,
      ),
    );
  }
}
