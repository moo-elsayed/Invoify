import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/widgets/custom_keyboard_unfocus.dart';
import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomKeyboardUnfocus Tests', () {
    testWidgets('unfocuses text field when tapping outside', (
      WidgetTester tester,
    ) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomKeyboardUnfocus(
            child: Column(
              children: [
                TextField(focusNode: focusNode),
                const SizedBox(height: 50, child: Text('Outside Area')),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Focus the text field
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);

      // Tap outside
      await tester.tap(find.text('Outside Area'));
      await tester.pumpAndSettle();

      // Keyboard should be unfocused
      expect(focusNode.hasFocus, isFalse);
    });
  });
}
