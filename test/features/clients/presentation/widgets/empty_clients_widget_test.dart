import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/clients/presentation/widgets/empty_clients_widget.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('EmptyClientsWidget Tests', () {
    testWidgets('renders AppStrings.noClientsYet when not searching', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const EmptyClientsWidget(isSearching: false),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.noClientsYet), findsOneWidget);
    });

    testWidgets('renders AppStrings.noClientsFound when searching', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const EmptyClientsWidget(isSearching: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.noClientsFound), findsOneWidget);
    });
  });
}
