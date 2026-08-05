import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_error_widget.dart';
import 'package:invoify/core/widgets/main_screen_header.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_state.dart';
import 'package:invoify/features/invoices/presentation/views/invoices_view.dart';
import 'package:invoify/features/invoices/presentation/widgets/empty_invoices_widget.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_card.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_skeleton_list.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockInvoicesCubit extends MockCubit<InvoicesState>
    implements InvoicesCubit {}

void main() {
  late MockInvoicesCubit mockInvoicesCubit;

  final List<InvoiceEntity> tInvoices = [
    InvoiceEntity(
      invoiceId: 'inv-1',
      invoiceNumber: 'INV-001',
      client: const ClientEntity(clientId: 'c1', name: 'Acme Corp'),
      items: const [],
      subtotal: 500,
      taxRate: 0,
      taxAmount: 0,
      discountAmount: 0,
      totalAmount: 500,
      status: InvoiceStatus.paid,
      createdAt: DateTime.now(),
    ),
    InvoiceEntity(
      invoiceId: 'inv-2',
      invoiceNumber: 'INV-002',
      client: const ClientEntity(clientId: 'c2', name: 'Stark Industries'),
      items: const [],
      subtotal: 1200,
      taxRate: 0,
      taxAmount: 0,
      discountAmount: 0,
      totalAmount: 1200,
      status: InvoiceStatus.overdue,
      createdAt: DateTime.now(),
    ),
  ];

  setUp(() {
    mockInvoicesCubit = MockInvoicesCubit();
    when(() => mockInvoicesCubit.state).thenReturn(const InvoicesInitial());
    when(() => mockInvoicesCubit.allInvoices).thenReturn([]);
  });

  Widget buildTestableWidget() => createWidgetForTesting(
    child: BlocProvider<InvoicesCubit>.value(
      value: mockInvoicesCubit,
      child: const InvoicesView(),
    ),
  );

  group('InvoicesView Widget Tests', () {
    testWidgets('renders skeleton list when state is InvoicesLoading', (
      WidgetTester tester,
    ) async {
      when(() => mockInvoicesCubit.state).thenReturn(const InvoicesLoading());

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(MainScreenHeader), findsOneWidget);
      expect(find.byType(InvoiceSkeletonList), findsOneWidget);
    });

    testWidgets(
      'renders EmptyInvoicesWidget when allInvoices list is empty and state is InvoicesSuccess',
      (WidgetTester tester) async {
        when(
          () => mockInvoicesCubit.state,
        ).thenReturn(const InvoicesSuccess([]));
        when(() => mockInvoicesCubit.allInvoices).thenReturn([]);

        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(EmptyInvoicesWidget), findsOneWidget);
        expect(find.text(AppStrings.noInvoicesYet), findsOneWidget);
      },
    );

    testWidgets('renders CustomErrorWidget when state is InvoicesFailure', (
      WidgetTester tester,
    ) async {
      when(
        () => mockInvoicesCubit.state,
      ).thenReturn(const InvoicesFailure('Failed to load invoices'));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CustomErrorWidget), findsOneWidget);
      expect(find.text('Failed to load invoices'), findsOneWidget);
    });

    testWidgets(
      'renders list of InvoiceCards when state is InvoicesSuccess with invoices',
      (WidgetTester tester) async {
        when(
          () => mockInvoicesCubit.state,
        ).thenReturn(InvoicesSuccess(tInvoices));
        when(() => mockInvoicesCubit.allInvoices).thenReturn(tInvoices);

        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(InvoiceCard), findsNWidgets(2));
        expect(find.text('INV-001'), findsOneWidget);
        expect(find.text('INV-002'), findsOneWidget);
        expect(find.text('Acme Corp'), findsOneWidget);
        expect(find.text('Stark Industries'), findsOneWidget);
      },
    );

    testWidgets(
      'filters invoice list by status when a status tab is selected',
      (WidgetTester tester) async {
        when(
          () => mockInvoicesCubit.state,
        ).thenReturn(InvoicesSuccess(tInvoices));
        when(() => mockInvoicesCubit.allInvoices).thenReturn(tInvoices);

        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        // Tap 'Paid' status tab
        await tester.tap(find.text(AppStrings.statusPaid).first);
        await tester.pumpAndSettle();

        // Only INV-001 (Paid) should remain in filtered view
        expect(find.text('INV-001'), findsOneWidget);
        expect(find.text('INV-002'), findsNothing);
      },
    );
  });
}
