import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/features/auth/presentation/widgets/auth_redirect_text.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('AuthRedirectText Tests', () {
    testWidgets('renders question and action text correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const AuthRedirectText(
            question: "Don't have an account?",
            action: 'Register',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RichText), findsOneWidget);

      final richTextWidget = tester.widget<RichText>(find.byType(RichText));
      final textSpan = richTextWidget.text as TextSpan;
      expect(textSpan.toPlainText(), contains("Don't have an account?"));
      expect(textSpan.toPlainText(), contains('Register'));
    });

    testWidgets('triggers onTap recognizer when action text is tapped', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: AuthRedirectText(
            question: "Don't have an account?",
            action: 'Register',
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final richTextWidget = tester.widget<RichText>(find.byType(RichText));
      final textSpan = richTextWidget.text as TextSpan;
      final actionSpan = textSpan.children![2] as TextSpan;

      (actionSpan.recognizer as TapGestureRecognizer).onTap!();
      expect(tapped, isTrue);
    });
  });
}
