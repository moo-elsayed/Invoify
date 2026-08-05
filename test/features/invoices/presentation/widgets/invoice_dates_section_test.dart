import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_dates_section.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('InvoiceDatesSection Tests', () {
    final now = DateTime(2026, 8, 5);

    testWidgets('renders formatted issue date and due date correctly', (
      WidgetTester tester,
    ) async {
      final issueNotifier = ValueNotifier<DateTime>(now);
      final dueNotifier = ValueNotifier<DateTime>(
        now.add(const Duration(days: 14)),
      );

      await tester.pumpWidget(
        createWidgetForTesting(
          child: InvoiceDatesSection(
            issueDateNotifier: issueNotifier,
            dueDateNotifier: dueNotifier,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.issueDate), findsOneWidget);
      expect(find.text(AppStrings.dueDate), findsOneWidget);
      expect(find.text(DateFormat('yyyy-MM-dd').format(now)), findsOneWidget);
      expect(
        find.text(
          DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 14))),
        ),
        findsOneWidget,
      );
    });
  });
}
