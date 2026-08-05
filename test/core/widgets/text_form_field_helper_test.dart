import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';
import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('TextFormFieldHelper Tests', () {
    testWidgets('renders hint text and label text correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const TextFormFieldHelper(
            hint: 'Enter your email',
            labelText: 'Email',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('triggers onChanged and text direction updates on input', (
      WidgetTester tester,
    ) async {
      String changedText = '';

      await tester.pumpWidget(
        createWidgetForTesting(
          child: TextFormFieldHelper(
            onChanged: (val) => changedText = val ?? '',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'Hello');
      expect(changedText, equals('Hello'));

      // Test Arabic text direction switch
      await tester.enterText(find.byType(TextFormField), 'مرحبا');
      await tester.pumpAndSettle();
      expect(changedText, equals('مرحبا'));
    });

    testWidgets('toggles password visibility when isPassword is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const TextFormFieldHelper(isPassword: true, hint: 'Password'),
        ),
      );
      await tester.pumpAndSettle();

      // Initially visibility icon should be visibility_outlined
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

      // Tap toggle icon
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      // Now visibility_off_outlined should be displayed
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);
    });

    testWidgets(
      'displays validation error message when validator returns error',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          createWidgetForTesting(
            child: Form(
              key: formKey,
              child: TextFormFieldHelper(
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        formKey.currentState!.validate();
        await tester.pumpAndSettle();

        expect(find.text('Field is required'), findsOneWidget);
      },
    );

    testWidgets('renders prefixIcon, suffixWidget, and suffixText', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const TextFormFieldHelper(
            prefixIcon: Icon(Icons.email),
            suffixWidget: Icon(Icons.check),
            suffixText: 'USD',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('USD'), findsOneWidget);
    });

    testWidgets('respects readOnly and onTap properties', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: TextFormFieldHelper(
            readOnly: true,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(editableText.readOnly, isTrue);

      await tester.tap(find.byType(TextFormField));
      expect(tapped, isTrue);
    });
  });
}
