import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_success_dialog.dart';
import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomSuccessDialog Tests', () {
    testWidgets('renders check icon, message text, and default OK button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomSuccessDialog(
            text: 'Account Created Successfully!',
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.text('Account Created Successfully!'), findsOneWidget);
      expect(find.text(AppStrings.ok), findsOneWidget);
    });

    testWidgets('renders custom button text when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomSuccessDialog(
            text: 'Email Sent',
            buttonText: 'Continue',
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Email Sent'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('triggers onPressed callback when button is tapped', (
      WidgetTester tester,
    ) async {
      bool pressed = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomSuccessDialog(
            text: 'Success',
            onPressed: () => pressed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.ok));
      expect(pressed, isTrue);
    });
  });
}
