import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/presentation/view_models/clients_cubit/clients_cubit.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_item_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_state.dart';
import 'package:invoify/features/invoices/presentation/views/add_edit_invoice_view.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_badge_number.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_calculation_summary.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_client_picker.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_dates_section.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_items_section.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockInvoicesCubit extends MockCubit<InvoicesState>
    implements InvoicesCubit {}

class MockClientsCubit extends MockCubit<ClientsState>
    implements ClientsCubit {}

class FakeInvoiceEntity extends Fake implements InvoiceEntity {}

void main() {
  late MockInvoicesCubit mockInvoicesCubit;
  late MockClientsCubit mockClientsCubit;

  setUpAll(() {
    registerFallbackValue(FakeInvoiceEntity());
  });

  final tExistingInvoice = InvoiceEntity(
    invoiceId: 'inv-100',
    invoiceNumber: 'INV-100',
    client: const ClientEntity(clientId: 'c1', name: 'Acme Corp'),
    items: const [
      InvoiceItemEntity(
        itemId: 'item-1',
        name: 'Web Development',
        quantity: 1,
        unitPrice: 1000,
      ),
    ],
    subtotal: 1000,
    taxRate: 14,
    taxAmount: 140,
    discountAmount: 0,
    totalAmount: 1140,
    status: InvoiceStatus.paid,
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockInvoicesCubit = MockInvoicesCubit();
    mockClientsCubit = MockClientsCubit();

    when(() => mockInvoicesCubit.state).thenReturn(const InvoicesInitial());
    when(() => mockInvoicesCubit.allInvoices).thenReturn([]);

    when(() => mockClientsCubit.state).thenReturn(ClientsInitial());
    when(() => mockClientsCubit.allClients).thenReturn([]);
    when(() => mockClientsCubit.getClients()).thenAnswer((_) async {});

    if (GetIt.instance.isRegistered<InvoicesCubit>()) {
      GetIt.instance.unregister<InvoicesCubit>();
    }
    GetIt.instance.registerFactory<InvoicesCubit>(() => mockInvoicesCubit);

    if (GetIt.instance.isRegistered<ClientsCubit>()) {
      GetIt.instance.unregister<ClientsCubit>();
    }
    GetIt.instance.registerFactory<ClientsCubit>(() => mockClientsCubit);
  });

  Widget buildTestableWidget({InvoiceEntity? invoice}) =>
      createWidgetForTesting(
        child: BlocProvider<InvoicesCubit>.value(
          value: mockInvoicesCubit,
          child: BlocProvider<ClientsCubit>.value(
            value: mockClientsCubit,
            child: AddEditInvoiceView(invoice: invoice),
          ),
        ),
      );

  group('AddEditInvoiceView Widget Tests', () {
    testWidgets('renders all invoice form sections in Add Mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(
        find.text(AppStrings.createInvoice),
        findsNWidgets(2),
      ); // AppBar title & Save button
      expect(find.byType(InvoiceNumberBadge), findsOneWidget);
      expect(find.byType(InvoiceClientPicker), findsOneWidget);
      expect(find.byType(InvoiceDatesSection), findsOneWidget);
      expect(find.byType(InvoiceItemsSection), findsOneWidget);
      expect(find.byType(InvoiceCalculationSummary), findsOneWidget);
    });

    testWidgets('pre-fills existing invoice data in Edit Mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(invoice: tExistingInvoice));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.editInvoice), findsOneWidget);
      expect(find.text('Acme Corp'), findsOneWidget);
      expect(find.text('Web Development'), findsOneWidget);
    });

    testWidgets(
      'displays validation error if submitting without selecting client or adding item',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        final saveBtn = find.widgetWithText(
          CustomMaterialButton,
          AppStrings.createInvoice,
        );
        await tester.ensureVisible(saveBtn);
        await tester.pumpAndSettle();

        await tester.tap(saveBtn);
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.pleaseSelectClient), findsWidgets);
        await tester.pump(const Duration(seconds: 5));

        verifyNever(() => mockInvoicesCubit.createInvoice(any()));
      },
    );
  });
}
