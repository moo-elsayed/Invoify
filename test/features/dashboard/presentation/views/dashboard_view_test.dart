import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_error_widget.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/dashboard/presentation/view_models/dashboard_cubit/dashboard_cubit.dart';
import 'package:invoify/features/dashboard/presentation/view_models/dashboard_cubit/dashboard_state.dart';
import 'package:invoify/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_metrics_cards.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_recent_invoices.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_revenue_chart.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_skeleton_loading.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_status_chart.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockDashboardCubit extends MockCubit<DashboardState>
    implements DashboardCubit {}

void main() {
  late MockDashboardCubit mockDashboardCubit;

  final tRecentInvoices = [
    InvoiceEntity(
      invoiceId: 'inv-1',
      invoiceNumber: 'INV-001',
      client: const ClientEntity(clientId: 'c1', name: 'Acme Corp'),
      totalAmount: 1200,
      status: InvoiceStatus.paid,
      createdAt: DateTime.now(),
    ),
  ];

  const tSuccessState = DashboardSuccess(
    monthlyEarnings: 5000,
    totalOverdue: 1200,
    pendingAmount: 3000,
    totalClientsCount: 15,
    monthlyRevenueMap: {1: 1000, 2: 2000, 3: 5000},
    statusDistribution: {
      InvoiceStatus.paid: 5,
      InvoiceStatus.sent: 3,
      InvoiceStatus.draft: 2,
    },
    recentInvoices: [],
  );

  setUp(() {
    mockDashboardCubit = MockDashboardCubit();
    when(() => mockDashboardCubit.state).thenReturn(const DashboardInitial());
  });

  Widget buildTestableWidget() => createWidgetForTesting(
    child: BlocProvider<DashboardCubit>.value(
      value: mockDashboardCubit,
      child: const DashboardView(),
    ),
  );

  group('DashboardView Widget Tests', () {
    testWidgets(
      'renders DashboardSkeletonLoading when state is DashboardLoading',
      (WidgetTester tester) async {
        when(
          () => mockDashboardCubit.state,
        ).thenReturn(const DashboardLoading());

        await tester.pumpWidget(buildTestableWidget());
        await tester.pump();

        expect(find.byType(DashboardSkeletonLoading), findsOneWidget);
      },
    );

    testWidgets('renders CustomErrorWidget when state is DashboardFailure', (
      WidgetTester tester,
    ) async {
      when(
        () => mockDashboardCubit.state,
      ).thenReturn(const DashboardFailure('Failed to load dashboard'));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(CustomErrorWidget), findsOneWidget);
      expect(find.text('Failed to load dashboard'), findsOneWidget);
    });

    testWidgets(
      'renders DashboardView components when state is DashboardSuccess',
      (WidgetTester tester) async {
        when(() => mockDashboardCubit.state).thenReturn(tSuccessState);

        await tester.pumpWidget(buildTestableWidget());
        await tester.pump();

        expect(find.text(AppStrings.home), findsOneWidget);
        expect(find.byType(DashboardMetricsCards), findsOneWidget);
        expect(find.byType(DashboardRevenueChart), findsOneWidget);
        expect(find.byType(DashboardStatusChart), findsOneWidget);
        expect(find.byType(DashboardRecentInvoices), findsOneWidget);
        expect(find.text(AppStrings.noInvoicesYet), findsOneWidget);
      },
    );

    testWidgets('renders recent invoices when state contains recentInvoices', (
      WidgetTester tester,
    ) async {
      final stateWithInvoices = DashboardSuccess(
        monthlyEarnings: 5000,
        totalOverdue: 1200,
        pendingAmount: 3000,
        totalClientsCount: 15,
        monthlyRevenueMap: const {1: 1000, 2: 2000, 3: 5000},
        statusDistribution: const {InvoiceStatus.paid: 5},
        recentInvoices: tRecentInvoices,
      );
      when(() => mockDashboardCubit.state).thenReturn(stateWithInvoices);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.text('INV-001'), findsOneWidget);
      expect(find.text('Acme Corp'), findsOneWidget);
    });
  });
}
