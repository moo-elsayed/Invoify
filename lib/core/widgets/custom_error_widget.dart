import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
    this.buttonText,
  });

  final String error;
  final VoidCallback onRetry;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: EdgeInsets.all(24.w),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48.sp,
                  color: colors.error,
                ),
              ),
              Gap(16.h),
              Text(
                error,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14Medium.copyWith(
                  color: colors.subText,
                ),
              ),
              Gap(20.h),
              CustomMaterialButton(
                onPressed: onRetry,
                text: buttonText ?? AppStrings.ok,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
