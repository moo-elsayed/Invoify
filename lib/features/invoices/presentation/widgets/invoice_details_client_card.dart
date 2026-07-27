import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';

class InvoiceDetailsClientCard extends StatelessWidget {
  const InvoiceDetailsClientCard({super.key, required this.client});

  final ClientEntity client;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final hasContactInfo =
        client.email.isNotEmpty ||
        client.phone.isNotEmpty ||
        client.address.isNotEmpty;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.clientInformation,
            style: AppTextStyles.font14Bold.copyWith(color: colors.mainText),
          ),
          Gap(14.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: colors.primary,
                  size: 18.sp,
                ),
              ),
              Gap(8.w),
              Text(
                client.name,
                style: AppTextStyles.font15SemiBold.copyWith(
                  color: colors.mainText,
                ),
              ),
            ],
          ),
          if (hasContactInfo) ...[
            Gap(10.h),
            Divider(color: colors.border.withValues(alpha: 0.5), height: 1),
            Gap(10.h),
          ],
          if (client.email.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.email_outlined, color: colors.subText, size: 16.sp),
                Gap(8.w),
                Expanded(
                  child: Text(
                    client.email,
                    style: AppTextStyles.font13Regular.copyWith(
                      color: colors.subText,
                    ),
                  ),
                ),
              ],
            ),
            if (client.phone.isNotEmpty || client.address.isNotEmpty) Gap(8.h),
          ],
          if (client.phone.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.phone_outlined, color: colors.subText, size: 16.sp),
                Gap(8.w),
                Expanded(
                  child: Text(
                    client.phone,
                    style: AppTextStyles.font13Regular.copyWith(
                      color: colors.subText,
                    ),
                  ),
                ),
              ],
            ),
            if (client.address.isNotEmpty) Gap(8.h),
          ],
          if (client.address.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: colors.subText,
                  size: 16.sp,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    client.address,
                    style: AppTextStyles.font13Regular.copyWith(
                      color: colors.subText,
                    ),
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
