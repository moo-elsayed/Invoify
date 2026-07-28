import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';

class DashboardMetricItemCard extends StatelessWidget {
  const DashboardMetricItemCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.isDarkMode
              ? colors.border.withValues(alpha: 0.5)
              : colors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, size: 20.sp, color: accentColor),
              ),
              Icon(Icons.trending_up_rounded, size: 16.sp, color: accentColor),
            ],
          ),
          Gap(12.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font18Bold.copyWith(color: colors.mainText),
          ),
          Gap(4.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font12Medium.copyWith(color: colors.subText),
          ),
        ],
      ),
    );
  }
}
