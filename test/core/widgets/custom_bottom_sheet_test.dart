import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/utils/custom_bottom_sheet_selection_item.dart';
import 'package:invoify/core/widgets/custom_bottom_sheet.dart';
import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomBottomSheet Tests', () {
    testWidgets('renders title, subtitle, and list of items', (
      WidgetTester tester,
    ) async {
      final items = [
        CustomBottomSheetSelectionItem<String>(
          title: 'Option 1',
          subtitle: 'Sub 1',
          value: 'opt1',
          isSelected: true,
          onTap: () {},
          icon: Icons.check,
        ),
        CustomBottomSheetSelectionItem<String>(
          title: 'Option 2',
          value: 'opt2',
          isSelected: false,
          onTap: () {},
        ),
      ];

      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomBottomSheet(
            title: 'Select Option',
            subtitle: 'Choose one of the choices',
            items: items,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Select Option'), findsOneWidget);
      expect(find.text('Choose one of the choices'), findsOneWidget);
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked_rounded), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_off_rounded), findsOneWidget);
    });

    testWidgets('triggers item onTap callback when tapped', (
      WidgetTester tester,
    ) async {
      bool optionTapped = false;

      final items = [
        CustomBottomSheetSelectionItem<String>(
          title: 'Option 1',
          value: 'opt1',
          isSelected: false,
          onTap: () => optionTapped = true,
        ),
      ];

      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomBottomSheet(title: 'Select Option', items: items),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 1'));
      expect(optionTapped, isTrue);
    });
  });
}
