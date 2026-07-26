import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ClientPickerSkeletonList extends StatelessWidget {
  const ClientPickerSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 4,
        separatorBuilder: (context, index) => Gap(10.h),
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: colors.primary,
                  size: 20.sp,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client Name Placeholder',
                      style: AppTextStyles.font14Bold.copyWith(
                        color: colors.mainText,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      'client.email@example.com',
                      style: AppTextStyles.font12Medium.copyWith(
                        color: colors.subText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
