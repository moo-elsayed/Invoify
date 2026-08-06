import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_metric_item_card.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_metrics_cards.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('DashboardMetricsCards Tests', () {
    testWidgets('renders all metric item cards with correct titles', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const DashboardMetricsCards(
            monthlyEarnings: 15000,
            totalOverdue: 2500,
            pendingAmount: 4000,
            activeClientsCount: 8,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DashboardMetricItemCard), findsNWidgets(4));
      expect(find.text(AppStrings.monthlyEarnings), findsOneWidget);
      expect(find.text(AppStrings.totalOverdue), findsOneWidget);
      expect(find.text(AppStrings.pendingAmount), findsOneWidget);
      expect(find.text(AppStrings.activeClients), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
      expect(find.textContaining('15'), findsWidgets);
    });
  });
}
