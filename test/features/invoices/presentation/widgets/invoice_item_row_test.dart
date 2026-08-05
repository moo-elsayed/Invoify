import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_item_entity.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_item_row.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('InvoiceItemRow Tests', () {
    const tItem = InvoiceItemEntity(
      itemId: 'item-1',
      name: 'Logo Design',
      quantity: 2,
      unitPrice: 250,
    );

    testWidgets('renders item inputs and calculates subtotal automatically', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: InvoiceItemRow(
            item: tItem,
            index: 0,
            onRemove: () {},
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextFormFieldHelper), findsNWidgets(3));
      expect(find.text('2'), findsOneWidget);
      expect(find.text('250'), findsOneWidget);
      expect(find.textContaining('500'), findsOneWidget);
      expect(find.text('Logo Design'), findsOneWidget);
    });

    testWidgets('triggers onChanged when item quantity or price is edited', (
      WidgetTester tester,
    ) async {
      InvoiceItemEntity? updatedItem;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: InvoiceItemRow(
            item: const InvoiceItemEntity(),
            index: 0,
            onRemove: () {},
            onChanged: (item) => updatedItem = item,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'SEO Audit');
      await tester.pumpAndSettle();

      expect(updatedItem?.name, equals('SEO Audit'));
    });

    testWidgets('triggers onRemove callback when delete icon is tapped', (
      WidgetTester tester,
    ) async {
      bool removed = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: InvoiceItemRow(
            item: tItem,
            index: 0,
            onRemove: () => removed = true,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      expect(removed, isTrue);
    });
  });
}
