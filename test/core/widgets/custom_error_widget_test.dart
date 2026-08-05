import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_error_widget.dart';
import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomErrorWidget Tests', () {
    testWidgets('renders error text and default button text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomErrorWidget(
            error: 'Something went wrong',
            onRetry: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
      expect(find.text(AppStrings.ok), findsOneWidget);
    });

    testWidgets('renders custom button text when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomErrorWidget(
            error: 'Connection Failed',
            buttonText: 'Try Again',
            onRetry: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Connection Failed'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('triggers onRetry callback when button is tapped', (
      WidgetTester tester,
    ) async {
      bool retried = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomErrorWidget(
            error: 'Network Error',
            onRetry: () => retried = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.ok));
      expect(retried, isTrue);
    });
  });
}
