import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/helpers/extensions.dart';
import '../../../../../core/helpers/app_strings.dart';
import '../../../../../core/theming/app_text_styles.dart';
import '../view_models/onboarding_cubit/onboarding_cubit.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key, required this.isLastPage});

  final bool isLastPage;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: isLastPage ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 250),
        child: IgnorePointer(
          ignoring: isLastPage,
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: 20.w, top: 12.h),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: InkWell(
                onTap: () => context.read<OnboardingCubit>().setFirstTime(),
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: context.colors.primary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    AppStrings.skip,
                    style: AppTextStyles.font14SemiBold.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
