import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_client_picker.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('InvoiceClientPicker Tests', () {
    testWidgets('renders pleaseSelectClient text when no client is selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: InvoiceClientPicker(
            selectedClient: null,
            onClientSelected: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.selectClient), findsOneWidget);
      expect(find.text(AppStrings.pleaseSelectClient), findsOneWidget);
    });

    testWidgets('renders client name when a client is selected', (
      WidgetTester tester,
    ) async {
      const tClient = ClientEntity(clientId: 'c1', name: 'Wayne Enterprises');

      await tester.pumpWidget(
        createWidgetForTesting(
          child: InvoiceClientPicker(
            selectedClient: tClient,
            onClientSelected: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Wayne Enterprises'), findsOneWidget);
    });
  });
}
