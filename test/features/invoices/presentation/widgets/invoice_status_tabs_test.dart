import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_status_tabs.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('InvoiceStatusTabs Tests', () {
    final List<InvoiceEntity> tInvoices = [
      InvoiceEntity(
        invoiceId: '1',
        invoiceNumber: 'INV-001',
        client: const ClientEntity(clientId: 'c1', name: 'Client 1'),
        items: const [],
        subtotal: 100,
        taxRate: 0,
        taxAmount: 0,
        discountAmount: 0,
        totalAmount: 100,
        status: InvoiceStatus.paid,
        createdAt: DateTime.now(),
      ),
      InvoiceEntity(
        invoiceId: '2',
        invoiceNumber: 'INV-002',
        client: const ClientEntity(clientId: 'c2', name: 'Client 2'),
        items: const [],
        subtotal: 200,
        taxRate: 0,
        taxAmount: 0,
        discountAmount: 0,
        totalAmount: 200,
        status: InvoiceStatus.sent,
        createdAt: DateTime.now(),
      ),
    ];

    testWidgets('renders all status tabs and correct invoice counts', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: InvoiceStatusTabs(
            selectedStatus: null,
            onStatusSelected: (_) {},
            allInvoices: tInvoices,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.all), findsOneWidget);
      expect(find.text(AppStrings.statusPaid), findsOneWidget);
      expect(find.text(AppStrings.statusSent), findsOneWidget);

      // All count should be 2
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('triggers onStatusSelected callback when tab is pressed', (
      WidgetTester tester,
    ) async {
      InvoiceStatus? selected;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: InvoiceStatusTabs(
            selectedStatus: null,
            onStatusSelected: (status) => selected = status,
            allInvoices: tInvoices,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.statusPaid));
      expect(selected, equals(InvoiceStatus.paid));
    });
  });
}
