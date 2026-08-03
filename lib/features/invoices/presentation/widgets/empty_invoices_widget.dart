import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';

class EmptyInvoicesWidget extends StatelessWidget {
  const EmptyInvoicesWidget({super.key, required this.isFiltered});

  final bool isFiltered;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 56.sp,
                color: colors.primary,
              ),
            ),
            Gap(16.h),
            Text(
              isFiltered
                  ? AppStrings.noInvoicesFound
                  : AppStrings.noInvoicesYet,
              style: AppTextStyles.font16Bold.copyWith(color: colors.mainText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
