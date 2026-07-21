import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/theming/app_text_styles.dart';
import '../utils/onboarding_item.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({super.key, required this.slide});

  final OnboardingItem slide;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        flex: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: FadeInDown(
            from: 30,
            duration: const Duration(milliseconds: 600),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.r),
                color: context.isDarkMode
                    ? context.colors.surface.withValues(alpha: 0.5)
                    : context.colors.primary.withValues(alpha: 0.04),
                border: Border.all(
                  color: context.isDarkMode
                      ? context.colors.border.withValues(alpha: 0.4)
                      : context.colors.primary.withValues(alpha: 0.08),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Lottie.asset(slide.animation, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 16.h),
      Expanded(
        flex: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              FadeInUp(
                from: 20,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font24Bold.copyWith(
                    color: context.colors.mainText,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              FadeInUp(
                from: 20,
                delay: const Duration(milliseconds: 150),
                duration: const Duration(milliseconds: 500),
                child: Text(
                  slide.description,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font15Medium.copyWith(
                    color: context.colors.subText,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
