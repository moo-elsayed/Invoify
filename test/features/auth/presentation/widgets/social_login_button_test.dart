import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/features/auth/presentation/widgets/social_login_button.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('SocialLoginButton Tests', () {
    testWidgets('renders text and social icon when not loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: SocialLoginButton(
            socialIcon: const Icon(Icons.g_mobiledata),
            onPressed: () {},
            text: 'Sign in with Google',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
    });

    testWidgets(
      'shows loading indicator and hides icon when isLoading is true',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createWidgetForTesting(
            child: SocialLoginButton(
              socialIcon: const Icon(Icons.g_mobiledata),
              isLoading: true,
              onPressed: () {},
              text: 'Sign in with Google',
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
        expect(find.byIcon(Icons.g_mobiledata), findsNothing);
      },
    );

    testWidgets('triggers onPressed callback when tapped', (
      WidgetTester tester,
    ) async {
      bool pressed = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: SocialLoginButton(
            socialIcon: const Icon(Icons.g_mobiledata),
            onPressed: () => pressed = true,
            text: 'Sign in with Google',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in with Google'));
      expect(pressed, isTrue);
    });
  });
}
