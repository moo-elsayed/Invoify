import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key, this.user});

  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final userEmail = user?.email ?? '';
    final displayName = user?.displayName ?? '';
    final isVerified = user?.isVerified ?? false;

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
        boxShadow: [
          BoxShadow(
            color: context.isDarkMode
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: colors.primary.withValues(alpha: 0.15),
            child: Icon(
              Icons.business_rounded,
              color: colors.primary,
              size: 28.sp,
            ),
          ),
          Gap(14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        displayName,
                        style: AppTextStyles.font16Bold.copyWith(
                          color: colors.mainText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isVerified) ...[
                      Gap(6.w),
                      Icon(
                        Icons.verified_rounded,
                        color: colors.primary,
                        size: 18.sp,
                      ),
                    ],
                  ],
                ),
                Gap(4.h),
                Text(
                  userEmail,
                  style: AppTextStyles.font13Regular.copyWith(
                    color: colors.subText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
