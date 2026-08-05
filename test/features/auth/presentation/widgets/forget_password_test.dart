import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/auth/presentation/widgets/forget_password.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('ForgetPassword Tests', () {
    testWidgets(
      'renders AppStrings.forgotPassword and triggers onTap when tapped',
      (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          createWidgetForTesting(
            child: ForgetPassword(onTap: () => tapped = true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.forgotPassword), findsOneWidget);

        await tester.tap(find.text(AppStrings.forgotPassword));
        expect(tapped, isTrue);
      },
    );
  });
}
