import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/settings/presentation/widgets/account_detail_row.dart';

class AccountDetailsCard extends StatelessWidget {
  const AccountDetailsCard({
    super.key,
    this.user,
    required this.formattedDate,
  });

  final UserEntity? user;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isVerified = user?.isVerified ?? false;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20.r),
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
            children: [
              Icon(
                Icons.person_outline_rounded,
                color: colors.primary,
                size: 22.sp,
              ),
              Gap(8.w),
              Text(
                AppStrings.accountDetails,
                style: AppTextStyles.font15Bold.copyWith(
                  color: colors.mainText,
                ),
              ),
            ],
          ),
          Gap(16.h),

          // Email detail item
          AccountDetailRow(
            icon: Icons.email_outlined,
            label: AppStrings.email,
            value: user?.email ?? '',
          ),
          Divider(height: 24.h, color: colors.border.withValues(alpha: 0.5)),

          // Currency detail item
          AccountDetailRow(
            icon: Icons.monetization_on_outlined,
            label: AppStrings.currency,
            value: user?.currency ?? 'USD',
          ),
          Divider(height: 24.h, color: colors.border.withValues(alpha: 0.5)),

          // Account status item
          AccountDetailRow(
            icon: Icons.verified_user_outlined,
            label: AppStrings.accountStatus,
            valueWidget: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isVerified
                    ? colors.primary.withValues(alpha: 0.12)
                    : colors.subText.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isVerified ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                    size: 14.sp,
                    color: isVerified ? colors.primary : colors.subText,
                  ),
                  Gap(4.w),
                  Text(
                    isVerified ? AppStrings.verified : AppStrings.unverified,
                    style: AppTextStyles.font12Medium.copyWith(
                      color: isVerified ? colors.primary : colors.subText,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (formattedDate.isNotEmpty) ...[
            Divider(height: 24.h, color: colors.border.withValues(alpha: 0.5)),
            // Member since item
            AccountDetailRow(
              icon: Icons.calendar_today_rounded,
              label: AppStrings.memberSince,
              value: formattedDate,
            ),
          ],
        ],
      ),
    );
  }
}
