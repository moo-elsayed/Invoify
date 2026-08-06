import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_confirmation_dialog.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_item_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_state.dart';
import 'package:invoify/features/invoices/presentation/views/invoice_details_view.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_details_client_card.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_details_header_card.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_details_items_card.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_details_summary_card.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../helpers/test_widget_wrapper.dart';

class MockInvoicesCubit extends MockCubit<InvoicesState>
    implements InvoicesCubit {}

void main() {
  late MockInvoicesCubit mockInvoicesCubit;

  final tInvoice = InvoiceEntity(
    invoiceId: 'inv-300',
    invoiceNumber: 'INV-300',
    client: const ClientEntity(clientId: 'c1', name: 'Wayne Enterprises'),
    items: const [
      InvoiceItemEntity(
        itemId: 'item-1',
        name: 'Security Audit',
        quantity: 2,
        unitPrice: 1500,
      ),
    ],
    subtotal: 3000,
    taxRate: 10,
    taxAmount: 300,
    discountAmount: 100,
    totalAmount: 3200,
    notes: 'Payment due within 30 days',
    status: InvoiceStatus.sent,
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockInvoicesCubit = MockInvoicesCubit();
    when(() => mockInvoicesCubit.state).thenReturn(const InvoicesInitial());
    when(() => mockInvoicesCubit.allInvoices).thenReturn([tInvoice]);
  });

  group('InvoiceDetailsView Widget Tests', () {
    testWidgets('renders all invoice detail cards and financial summary', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: BlocProvider<InvoicesCubit>.value(
            value: mockInvoicesCubit,
            child: InvoiceDetailsView(invoice: tInvoice),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.invoiceDetails), findsOneWidget);
      expect(find.byType(InvoiceDetailsHeaderCard), findsOneWidget);
      expect(find.byType(InvoiceDetailsClientCard), findsOneWidget);
      expect(find.byType(InvoiceDetailsItemsCard), findsOneWidget);
      expect(find.byType(InvoiceDetailsSummaryCard), findsOneWidget);
      expect(
        find.widgetWithText(CustomMaterialButton, AppStrings.editInvoice),
        findsNothing,
      );
      expect(find.text('INV-300'), findsOneWidget);
      expect(find.text('Wayne Enterprises'), findsWidgets);
      expect(find.text('Security Audit'), findsOneWidget);
    });

    testWidgets(
      'shows delete confirmation dialog when delete button is tapped',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<InvoicesCubit>.value(
              value: mockInvoicesCubit,
              child: InvoiceDetailsView(invoice: tInvoice),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final deleteBtn = find.widgetWithText(
          CustomMaterialButton,
          AppStrings.deleteInvoice,
        );
        await tester.ensureVisible(deleteBtn);
        await tester.pumpAndSettle();

        await tester.tap(deleteBtn);
        await tester.pumpAndSettle();

        expect(find.byType(CustomConfirmationDialog), findsOneWidget);
        expect(find.text(AppStrings.deleteInvoiceConfirmation), findsOneWidget);
      },
    );

    testWidgets(
      'calls deleteInvoice on cubit when delete is confirmed in dialog',
      (WidgetTester tester) async {
        when(
          () => mockInvoicesCubit.deleteInvoice(any()),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<InvoicesCubit>.value(
              value: mockInvoicesCubit,
              child: InvoiceDetailsView(invoice: tInvoice),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final deleteBtn = find.widgetWithText(
          CustomMaterialButton,
          AppStrings.deleteInvoice,
        );
        await tester.ensureVisible(deleteBtn);
        await tester.pumpAndSettle();

        await tester.tap(deleteBtn);
        await tester.pumpAndSettle();

        // Tap confirm button in dialog
        final confirmBtn = find
            .widgetWithText(CustomMaterialButton, AppStrings.deleteInvoice)
            .last;
        await tester.tap(confirmBtn);
        await tester.pumpAndSettle();

        verify(() => mockInvoicesCubit.deleteInvoice('inv-300')).called(1);
      },
    );

    testWidgets(
      'renders send, edit, and delete buttons when invoice status is draft',
      (WidgetTester tester) async {
        final draftInvoice = tInvoice.copyWith(status: InvoiceStatus.draft);
        when(() => mockInvoicesCubit.allInvoices).thenReturn([draftInvoice]);

        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<InvoicesCubit>.value(
              value: mockInvoicesCubit,
              child: InvoiceDetailsView(invoice: draftInvoice),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.sendInvoice), findsOneWidget);
        expect(find.text(AppStrings.editInvoice), findsOneWidget);
        expect(find.text(AppStrings.deleteInvoice), findsOneWidget);
        expect(find.text(AppStrings.markAsPaid), findsNothing);
      },
    );

    testWidgets(
      'renders markAsPaid and delete buttons when invoice status is sent',
      (WidgetTester tester) async {
        final sentInvoice = tInvoice.copyWith(status: InvoiceStatus.sent);
        when(() => mockInvoicesCubit.allInvoices).thenReturn([sentInvoice]);

        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<InvoicesCubit>.value(
              value: mockInvoicesCubit,
              child: InvoiceDetailsView(invoice: sentInvoice),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.markAsPaid), findsOneWidget);
        expect(find.text(AppStrings.deleteInvoice), findsOneWidget);
        expect(find.text(AppStrings.sendInvoice), findsNothing);
        expect(find.text(AppStrings.editInvoice), findsNothing);
      },
    );

    testWidgets(
      'renders only delete button when invoice status is paid',
      (WidgetTester tester) async {
        final paidInvoice = tInvoice.copyWith(status: InvoiceStatus.paid);
        when(() => mockInvoicesCubit.allInvoices).thenReturn([paidInvoice]);

        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<InvoicesCubit>.value(
              value: mockInvoicesCubit,
              child: InvoiceDetailsView(invoice: paidInvoice),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.deleteInvoice), findsOneWidget);
        expect(find.text(AppStrings.sendInvoice), findsNothing);
        expect(find.text(AppStrings.editInvoice), findsNothing);
        expect(find.text(AppStrings.markAsPaid), findsNothing);
      },
    );
  });
}
