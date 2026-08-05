import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_item_entity.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_item_row.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_items_section.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('InvoiceItemsSection Tests', () {
    testWidgets('renders empty state warning when items list is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: InvoiceItemsSection(
            items: const [],
            onAddItem: () {},
            onRemoveItem: (_) {},
            onUpdateItem: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.pleaseAddAtLeastOneItem), findsOneWidget);
      expect(find.byType(InvoiceItemRow), findsNothing);
    });

    testWidgets('renders InvoiceItemRow widgets when items list has items', (
      WidgetTester tester,
    ) async {
      const items = [
        InvoiceItemEntity(
          itemId: 'i1',
          name: 'Item 1',
          quantity: 1,
          unitPrice: 100,
        ),
        InvoiceItemEntity(
          itemId: 'i2',
          name: 'Item 2',
          quantity: 2,
          unitPrice: 200,
        ),
      ];

      await tester.pumpWidget(
        createWidgetForTesting(
          child: SingleChildScrollView(
            child: InvoiceItemsSection(
              items: items,
              onAddItem: () {},
              onRemoveItem: (_) {},
              onUpdateItem: (_, _) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(InvoiceItemRow), findsNWidgets(2));
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('triggers onAddItem callback when add item button is pressed', (
      WidgetTester tester,
    ) async {
      bool added = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: InvoiceItemsSection(
            items: const [],
            onAddItem: () => added = true,
            onRemoveItem: (_) {},
            onUpdateItem: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.addItem));
      expect(added, isTrue);
    });
  });
}
