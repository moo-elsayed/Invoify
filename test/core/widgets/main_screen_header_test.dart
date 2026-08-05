import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/widgets/main_screen_header.dart';
import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('MainScreenHeader & HeaderActionButton Tests', () {
    testWidgets('MainScreenHeader renders title and optional action', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const MainScreenHeader(
            title: 'Invoices',
            action: Icon(Icons.add),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Invoices'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets(
      'HeaderActionButton renders label and icon and triggers onTap',
      (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          createWidgetForTesting(
            child: HeaderActionButton(
              label: 'New Invoice',
              icon: Icons.add,
              onTap: () => tapped = true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('New Invoice'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(find.byType(HeaderActionButton));
        expect(tapped, isTrue);
      },
    );
  });
}
