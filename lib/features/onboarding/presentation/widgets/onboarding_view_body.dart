import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../core/helpers/app_strings.dart';
import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/widgets/custom_material_button.dart';
import '../utils/onboarding_item.dart';
import '../view_models/onboarding_cubit/onboarding_cubit.dart';
import 'onboarding_page_view.dart';
import 'skip_button.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  late PageController _pageController;
  late ValueNotifier<int> _currentIndexNotifier;
  final List<OnboardingItem> slides = onboardingSlides;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentIndexNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _currentIndexNotifier,
          builder: (context, value, child) =>
              SkipButton(isLastPage: value == slides.length - 1),
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: OnboardingPageView(
            pageController: _pageController,
            slides: slides,
            onPageChanged: (index) => _currentIndexNotifier.value = index,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: SmoothPageIndicator(
            controller: _pageController,
            count: slides.length,
            axisDirection: Axis.horizontal,
            effect: ExpandingDotsEffect(
              spacing: 8.w,
              radius: 12.r,
              dotWidth: 10.w,
              dotHeight: 10.h,
              expansionFactor: 3.5,
              paintStyle: PaintingStyle.fill,
              dotColor: context.colors.border,
              activeDotColor: context.colors.primary,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 28.h, right: 24.w, left: 24.w),
          child: BlocListener<OnboardingCubit, OnboardingState>(
            listener: (context, state) {
              if (state is OnboardingNavigateToLogin) {
                context.pushReplacementNamed(Routes.loginView);
              }
            },
            child: ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (context, value, child) {
                final isLastPage = value == slides.length - 1;
                return CustomMaterialButton(
                  onPressed: () {
                    if (isLastPage) {
                      context.read<OnboardingCubit>().setFirstTime();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  maxWidth: true,
                  borderRadius: BorderRadius.circular(14.r),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  text: isLastPage ? AppStrings.getStarted : AppStrings.next,
                  icon: Icon(
                    isLastPage
                        ? Icons.check_circle_outline_rounded
                        : Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}
