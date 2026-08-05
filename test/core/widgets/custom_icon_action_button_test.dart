import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/widgets/custom_icon_action_button.dart';
import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomIconActionButton Tests', () {
    testWidgets('renders icon and triggers onTap when tapped', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomIconActionButton(
            icon: Icons.edit,
            color: Colors.blue,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);

      await tester.tap(find.byType(CustomIconActionButton));
      expect(tapped, isTrue);
    });

    testWidgets('customizes background color and icon size', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomIconActionButton(
            icon: Icons.delete,
            color: Colors.red,
            backgroundColor: Colors.red.withValues(alpha: 0.2),
            iconSize: 24,
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.delete));
      expect(iconWidget.color, equals(Colors.red));
      expect(iconWidget.size, equals(24));
    });
  });
}
