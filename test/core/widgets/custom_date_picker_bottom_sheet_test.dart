import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_date_picker_bottom_sheet.dart';
import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomDatePickerBottomSheet Tests', () {
    testWidgets('renders date picker bottom sheet with title and buttons', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(375 * 3, 812 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      DateTime? selectedDate;
      final testInitialDate = DateTime(2026, 8, 15);

      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomDatePickerBottomSheet(
            initialDate: testInitialDate,
            minimumDate: DateTime(2026, 1, 1),
            title: 'Choose Invoice Date',
            onDateSelected: (date) => selectedDate = date,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Choose Invoice Date'), findsOneWidget);
      expect(find.text(AppStrings.cancel), findsOneWidget);
      expect(find.text(AppStrings.ok), findsOneWidget);
      expect(find.byType(CupertinoDatePicker), findsOneWidget);

      await tester.tap(find.text(AppStrings.ok));
      expect(selectedDate, equals(testInitialDate));
    });
  });
}
