import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/invoice_status_badge.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('InvoiceStatusBadge Tests', () {
    testWidgets('renders all invoice status types correctly', (
      WidgetTester tester,
    ) async {
      final statuses = {
        InvoiceStatus.draft: AppStrings.statusDraft,
        InvoiceStatus.sent: AppStrings.statusSent,
        InvoiceStatus.opened: AppStrings.statusOpened,
        InvoiceStatus.paid: AppStrings.statusPaid,
        InvoiceStatus.overdue: AppStrings.statusOverdue,
        InvoiceStatus.cancelled: AppStrings.statusCancelled,
      };

      for (final entry in statuses.entries) {
        await tester.pumpWidget(
          createWidgetForTesting(child: InvoiceStatusBadge(status: entry.key)),
        );
        await tester.pumpAndSettle();

        expect(find.text(entry.value), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsNothing);
      }
    });

    testWidgets('shows dropdown icon when showDropdownIcon is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const InvoiceStatusBadge(
            status: InvoiceStatus.paid,
            showDropdownIcon: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.statusPaid), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
    });
  });
}
