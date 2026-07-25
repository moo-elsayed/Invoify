import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';

class EmptyClientsWidget extends StatelessWidget {
  const EmptyClientsWidget({
    super.key,
    required this.isSearching,
  });

  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
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
                isSearching
                    ? Icons.search_off_rounded
                    : Icons.person_add_alt_1_rounded,
                size: 54.sp,
                color: colors.primary,
              ),
            ),
            Gap(16.h),
            Text(
              isSearching
                  ? AppStrings.noClientsFound
                  : AppStrings.noClientsYet,
              textAlign: TextAlign.center,
              style: AppTextStyles.font16Bold.copyWith(
                color: colors.mainText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
