import 'package:invoify/core/constants/app_assets.dart';
import '../../../../core/helpers/app_strings.dart';

class OnboardingItem {
  OnboardingItem({
    required this.title,
    required this.description,
    required this.animation,
  });

  final String title;
  final String description;
  final String animation;
}

List<OnboardingItem> get onboardingSlides => [
      OnboardingItem(
        animation: AppAssets.onboardingAnimation1,
        title: AppStrings.onboardingTitle1,
        description: AppStrings.onboardingDesc1,
      ),
      OnboardingItem(
        animation: AppAssets.onboardingAnimation2,
        title: AppStrings.onboardingTitle2,
        description: AppStrings.onboardingDesc2,
      ),
      OnboardingItem(
        animation: AppAssets.onboardingAnimation3,
        title: AppStrings.onboardingTitle3,
        description: AppStrings.onboardingDesc3,
      ),
    ];

