import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';

class InvoiceDatesSectionCard extends StatelessWidget {
  const InvoiceDatesSectionCard({
    super.key,
    required this.issueDateStr,
    required this.dueDateStr,
    this.paidDateStr,
  });

  final String issueDateStr;
  final String dueDateStr;
  final String? paidDateStr;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasPaidDate = paidDateStr != null && paidDateStr!.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: context.isDarkMode
              ? colors.border.withValues(alpha: 0.5)
              : colors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.issueDate,
                    style: AppTextStyles.font12Regular.copyWith(
                      color: colors.subText,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    issueDateStr,
                    style: AppTextStyles.font14Medium.copyWith(
                      color: colors.mainText,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppStrings.dueDate,
                    style: AppTextStyles.font12Regular.copyWith(
                      color: colors.subText,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    dueDateStr,
                    style: AppTextStyles.font14Medium.copyWith(
                      color: colors.mainText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (hasPaidDate) ...[
            Gap(12.h),
            Divider(color: colors.border.withValues(alpha: 0.5), height: 1),
            Gap(12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: const Color(0xFF10B981),
                      size: 18.sp,
                    ),
                    Gap(6.w),
                    Text(
                      AppStrings.paidDate,
                      style: AppTextStyles.font12Medium.copyWith(
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                Text(
                  paidDateStr!,
                  style: AppTextStyles.font14Bold.copyWith(
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
