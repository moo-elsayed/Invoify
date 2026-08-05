import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/widgets/custom_app_bar.dart';
import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomAppBar Tests', () {
    testWidgets('renders title and back arrow icon by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const Scaffold(appBar: CustomAppBar(title: 'Dashboard')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('triggers onTap callback when back arrow is pressed', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: Scaffold(
            appBar: CustomAppBar(title: 'Details', onTap: () => tapped = true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      expect(tapped, isTrue);
    });

    testWidgets('hides back arrow when showArrowBack is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const Scaffold(
            appBar: CustomAppBar(title: 'Home', showArrowBack: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
    });

    testWidgets('renders actions widgets when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'Settings',
              actions: [
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
