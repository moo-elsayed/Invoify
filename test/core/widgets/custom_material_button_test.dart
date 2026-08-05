import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomMaterialButton Widget Tests', () {
    testWidgets('renders text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomMaterialButton(onPressed: () {}, text: 'Submit'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(MaterialButton), findsOneWidget);
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
    });

    testWidgets('triggers onPressed callback when tapped', (
      WidgetTester tester,
    ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomMaterialButton(
            onPressed: () => wasPressed = true,
            text: 'Click Me',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CustomMaterialButton));
      expect(wasPressed, isTrue);
    });

    testWidgets(
      'shows loading indicator and ignores tap when isLoading is true',
      (WidgetTester tester) async {
        bool wasPressed = false;

        await tester.pumpWidget(
          createWidgetForTesting(
            child: CustomMaterialButton(
              onPressed: () => wasPressed = true,
              text: 'Loading',
              isLoading: true,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);

        await tester.tap(find.byType(CustomMaterialButton));
        expect(wasPressed, isFalse);
      },
    );

    testWidgets('renders icon when provided (trailing vs leading)', (
      WidgetTester tester,
    ) async {
      // Trailing icon (default)
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomMaterialButton(
            onPressed: () {},
            text: 'Next',
            icon: const Icon(Icons.arrow_forward),
            isTrailingIcon: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);

      // Leading icon
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomMaterialButton(
            onPressed: () {},
            text: 'Back',
            icon: const Icon(Icons.arrow_back),
            isTrailingIcon: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('renders maxWidth double.infinity when maxWidth is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomMaterialButton(
            onPressed: () {},
            text: 'Full Width',
            maxWidth: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final materialButton = tester.widget<MaterialButton>(
        find.byType(MaterialButton),
      );
      expect(materialButton.minWidth, equals(double.infinity));
    });

    testWidgets('applies custom background and text colors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomMaterialButton(
            onPressed: () {},
            text: 'Styled Button',
            backgroundColor: Colors.red,
            textColor: Colors.yellow,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final materialButton = tester.widget<MaterialButton>(
        find.byType(MaterialButton),
      );
      expect(materialButton.color, equals(Colors.red));

      final textWidget = tester.widget<Text>(find.text('Styled Button'));
      expect(textWidget.style?.color, equals(Colors.yellow));
    });
  });
}
