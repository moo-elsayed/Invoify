import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key, this.user});

  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final displayName = user?.displayName ?? '';
    final userEmail = user?.email ?? '';
    final isVerified = user?.isVerified ?? false;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20.r),
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
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36.r,
            backgroundColor: colors.primary.withValues(alpha: 0.15),
            child: Icon(
              Icons.business_rounded,
              color: colors.primary,
              size: 36.sp,
            ),
          ),
          Gap(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  displayName,
                  style: AppTextStyles.font18Bold.copyWith(
                    color: colors.mainText,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isVerified) ...[
                Gap(6.w),
                Icon(
                  Icons.verified_rounded,
                  color: colors.primary,
                  size: 20.sp,
                ),
              ],
            ],
          ),
          Gap(4.h),
          Text(
            userEmail,
            style: AppTextStyles.font14Regular.copyWith(
              color: colors.subText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
