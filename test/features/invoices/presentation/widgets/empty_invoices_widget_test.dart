import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/invoices/presentation/widgets/empty_invoices_widget.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('EmptyInvoicesWidget Tests', () {
    testWidgets('renders AppStrings.noInvoicesYet when not filtered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const EmptyInvoicesWidget(isFiltered: false),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
      expect(find.text(AppStrings.noInvoicesYet), findsOneWidget);
    });

    testWidgets('renders AppStrings.noInvoicesFound when filtered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const EmptyInvoicesWidget(isFiltered: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
      expect(find.text(AppStrings.noInvoicesFound), findsOneWidget);
    });
  });
}
