import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/constants/app_assets.dart';
import '../../../../../core/helpers/app_strings.dart';
import '../../../../../core/helpers/extensions.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theming/app_text_styles.dart';
import '../view_models/splash_cubit/splash_cubit.dart';

class AnimatedSplashViewBody extends StatefulWidget {
  const AnimatedSplashViewBody({super.key});

  @override
  State<AnimatedSplashViewBody> createState() => _AnimatedSplashViewBodyState();
}

class _AnimatedSplashViewBodyState extends State<AnimatedSplashViewBody> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) => BlocListener<SplashCubit, SplashState>(
    listener: (context, state) {
      if (state is SplashSuccess) {
        switch (state.process) {
          case SplashProcess.navigateToOnboarding:
            context.pushReplacementNamed(Routes.onboardingView);
          case SplashProcess.navigateToLogin:
            context.pushReplacementNamed(Routes.loginView);
          case SplashProcess.navigateToHome:
            context.pushReplacementNamed(Routes.homeView);
          case SplashProcess.none:
            break;
        }
      }
    },
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.background,
            context.colors.surface,
            context.colors.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ZoomIn(
                  duration: const Duration(milliseconds: 1000),
                  child: Container(
                    padding: EdgeInsets.all(22.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.isDarkMode
                          ? context.colors.surface.withValues(alpha: 0.8)
                          : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.primary.withValues(alpha: 0.25),
                          blurRadius: 32,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: Image.asset(
                        AppAssets.appIcon,
                        height: 100.h,
                        width: 100.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                FadeInUp(
                  from: 20,
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'Invoify',
                    style: AppTextStyles.font32Bold.copyWith(
                      color: context.colors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                FadeInUp(
                  from: 15,
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    AppStrings.appTagline,
                    style: AppTextStyles.font14Medium.copyWith(
                      color: context.colors.subText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50.h,
            left: 0,
            right: 0,
            child: Center(
              child: FadeIn(
                delay: const Duration(milliseconds: 800),
                child: SizedBox(
                  width: 26.w,
                  height: 26.h,
                  child: CupertinoActivityIndicator(
                    radius: 13.r,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
