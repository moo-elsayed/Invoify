import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/dashboard/presentation/widgets/status_chart_legend_item.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';

class DashboardStatusChart extends StatelessWidget {
  const DashboardStatusChart({super.key, required this.statusDistribution});

  final Map<InvoiceStatus, int> statusDistribution;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final totalCount = statusDistribution.values.fold<int>(0, (a, b) => a + b);
    final paidCount = statusDistribution[InvoiceStatus.paid] ?? 0;
    final sentCount = statusDistribution[InvoiceStatus.sent] ?? 0;
    final openedCount = statusDistribution[InvoiceStatus.opened] ?? 0;
    final overdueCount = statusDistribution[InvoiceStatus.overdue] ?? 0;
    final draftCount = statusDistribution[InvoiceStatus.draft] ?? 0;
    final cancelledCount = statusDistribution[InvoiceStatus.cancelled] ?? 0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.isDarkMode
              ? colors.border.withValues(alpha: 0.5)
              : colors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.invoiceBreakdown,
            style: AppTextStyles.font16Bold.copyWith(color: colors.mainText),
          ),
          Gap(16.h),
          if (totalCount == 0)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Text(
                  AppStrings.noAnalyticsData,
                  style: AppTextStyles.font13Regular.copyWith(
                    color: colors.subText,
                  ),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 140.h,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 36.r,
                        sections: [
                          if (paidCount > 0)
                            PieChartSectionData(
                              color: InvoiceStatus.paid.getColor(context),
                              value: paidCount.toDouble(),
                              title: '$paidCount',
                              radius: 28.r,
                              titleStyle: AppTextStyles.font12Bold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          if (sentCount > 0)
                            PieChartSectionData(
                              color: InvoiceStatus.sent.getColor(context),
                              value: sentCount.toDouble(),
                              title: '$sentCount',
                              radius: 28.r,
                              titleStyle: AppTextStyles.font12Bold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          if (openedCount > 0)
                            PieChartSectionData(
                              color: InvoiceStatus.opened.getColor(context),
                              value: openedCount.toDouble(),
                              title: '$openedCount',
                              radius: 28.r,
                              titleStyle: AppTextStyles.font12Bold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          if (overdueCount > 0)
                            PieChartSectionData(
                              color: InvoiceStatus.overdue.getColor(context),
                              value: overdueCount.toDouble(),
                              title: '$overdueCount',
                              radius: 28.r,
                              titleStyle: AppTextStyles.font12Bold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          if (draftCount > 0)
                            PieChartSectionData(
                              color: InvoiceStatus.draft.getColor(context),
                              value: draftCount.toDouble(),
                              title: '$draftCount',
                              radius: 28.r,
                              titleStyle: AppTextStyles.font12Bold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          if (cancelledCount > 0)
                            PieChartSectionData(
                              color: InvoiceStatus.cancelled.getColor(context),
                              value: cancelledCount.toDouble(),
                              title: '$cancelledCount',
                              radius: 28.r,
                              titleStyle: AppTextStyles.font12Bold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusChartLegendItem(
                      color: InvoiceStatus.paid.getColor(context),
                      label: AppStrings.statusPaid,
                      count: paidCount,
                    ),
                    Gap(6.h),
                    StatusChartLegendItem(
                      color: InvoiceStatus.sent.getColor(context),
                      label: AppStrings.statusSent,
                      count: sentCount,
                    ),
                    Gap(6.h),
                    StatusChartLegendItem(
                      color: InvoiceStatus.opened.getColor(context),
                      label: AppStrings.statusOpened,
                      count: openedCount,
                    ),
                    Gap(6.h),
                    StatusChartLegendItem(
                      color: InvoiceStatus.overdue.getColor(context),
                      label: AppStrings.statusOverdue,
                      count: overdueCount,
                    ),
                    Gap(6.h),
                    StatusChartLegendItem(
                      color: InvoiceStatus.draft.getColor(context),
                      label: AppStrings.statusDraft,
                      count: draftCount,
                    ),
                    Gap(6.h),
                    StatusChartLegendItem(
                      color: InvoiceStatus.cancelled.getColor(context),
                      label: AppStrings.statusCancelled,
                      count: cancelledCount,
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
