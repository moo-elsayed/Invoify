import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';

class DashboardRevenueChart extends StatelessWidget {
  const DashboardRevenueChart({super.key, required this.monthlyRevenueMap});

  final Map<int, double> monthlyRevenueMap;

  List<String> _getPastMonthsLabels() {
    final now = DateTime.now();
    final List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return List.generate(6, (i) {
      final targetDate = DateTime(now.year, now.month - (5 - i), 1);
      return monthNames[targetDate.month - 1];
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final labels = _getPastMonthsLabels();
    final maxRevenue = monthlyRevenueMap.values.fold<double>(
      0.0,
      (max, v) => v > max ? v : max,
    );
    final maxY = maxRevenue == 0 ? 100.0 : maxRevenue * 1.25;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.revenueOverview,
                style: AppTextStyles.font16Bold.copyWith(
                  color: colors.mainText,
                ),
              ),
              Icon(Icons.bar_chart_rounded, size: 20.sp, color: colors.primary),
            ],
          ),
          Gap(20.h),
          SizedBox(
            height: 180.h,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => colors.surface,
                    tooltipMargin: 5,
                    tooltipPadding: EdgeInsets.only(
                      top: 5.h,
                      right: 5.w,
                      left: 5.w,
                    ),
                    tooltipBorder: BorderSide(
                      width: 1,
                      color: context.isDarkMode
                          ? colors.border.withValues(alpha: 0.5)
                          : colors.border,
                    ),
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem(
                          context.formatCurrency(rod.toY),
                          AppTextStyles.font12Bold.copyWith(
                            color: colors.mainText,
                          ),
                        ),
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < labels.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              labels[index],
                              style: AppTextStyles.font11Medium.copyWith(
                                color: colors.subText,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(6, (index) {
                  final val = monthlyRevenueMap[index] ?? 0.0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: val,
                        gradient: LinearGradient(
                          colors: [
                            colors.primary,
                            colors.primary.withValues(alpha: 0.6),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 18.w,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
