import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/auth/presentation/widgets/or_divider.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrDivider Tests', () {
    testWidgets('renders OrDivider with AppStrings.or text and dividers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetForTesting(child: const OrDivider()));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.or), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));
    });
  });
}
