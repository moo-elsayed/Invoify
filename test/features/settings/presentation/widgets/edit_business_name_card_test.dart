import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/settings/presentation/widgets/edit_business_name_card.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('EditBusinessNameCard Widget Tests', () {
    late TextEditingController controller;
    late ValueNotifier<bool> isSavingNotifier;

    setUp(() {
      controller = TextEditingController(text: 'Acme LLC');
      isSavingNotifier = ValueNotifier<bool>(false);
    });

    tearDown(() {
      controller.dispose();
      isSavingNotifier.dispose();
    });

    testWidgets('renders input controller text and save button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: SingleChildScrollView(
            child: EditBusinessNameCard(
              controller: controller,
              isSavingNotifier: isSavingNotifier,
              onSave: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.businessName), findsOneWidget);
      expect(find.text('Acme LLC'), findsOneWidget);
      expect(find.text(AppStrings.saveChanges), findsOneWidget);
    });

    testWidgets('triggers onSave callback when save button is pressed', (
      WidgetTester tester,
    ) async {
      bool savePressed = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: SingleChildScrollView(
            child: EditBusinessNameCard(
              controller: controller,
              isSavingNotifier: isSavingNotifier,
              onSave: () => savePressed = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.saveChanges));
      expect(savePressed, isTrue);
    });
  });
}
