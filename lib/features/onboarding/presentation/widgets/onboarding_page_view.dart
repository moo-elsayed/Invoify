import 'package:flutter/material.dart';

import '../utils/onboarding_item.dart';
import 'page_view_item.dart';

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({
    super.key,
    required this.slides,
    this.onPageChanged,
    required this.pageController,
  });

  final PageController pageController;
  final List<OnboardingItem> slides;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) => PageView.builder(
    controller: pageController,
    itemCount: slides.length,
    onPageChanged: onPageChanged,
    itemBuilder: (context, index) => PageViewItem(slide: slides[index]),
  );
}
