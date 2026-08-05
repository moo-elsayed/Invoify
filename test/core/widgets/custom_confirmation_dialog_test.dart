import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/widgets/custom_confirmation_dialog.dart';
import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomConfirmationDialog Tests', () {
    testWidgets('renders title and subtitle correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomConfirmationDialog(
            title: 'Delete Item',
            subtitle: 'Are you sure you want to delete this invoice?',
            textConfirmButton: 'Delete',
            onConfirm: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Delete Item'), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete this invoice?'),
        findsOneWidget,
      );
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text(AppStrings.cancel), findsOneWidget);
    });

    testWidgets('triggers onConfirm callback when confirm button is pressed', (
      WidgetTester tester,
    ) async {
      bool confirmed = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomConfirmationDialog(
            title: 'Confirm Action',
            textConfirmButton: 'Yes',
            onConfirm: () => confirmed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yes'));
      expect(confirmed, isTrue);
    });

    testWidgets('triggers onCancel callback when cancel button is pressed', (
      WidgetTester tester,
    ) async {
      bool canceled = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomConfirmationDialog(
            title: 'Confirm Action',
            textConfirmButton: 'Yes',
            textCancelButton: 'No',
            onConfirm: () {},
            onCancel: () => canceled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('No'));
      expect(canceled, isTrue);
    });

    testWidgets('hides cancel button when showCancelButton is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomConfirmationDialog(
            title: 'Information',
            textConfirmButton: 'OK',
            showCancelButton: false,
            onConfirm: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('OK'), findsOneWidget);
      expect(find.text(AppStrings.cancel), findsNothing);
    });
  });
}
