import 'package:connect_four/app/common/color/app_color.dart' show AppColor;
import 'package:connect_four/app/data/models/onboardingItems/onboarding_data.dart';
import 'package:connect_four/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageViewDots extends StatelessWidget {
  const PageViewDots({super.key, required PageController pageController})
    : _pageController = pageController;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: _pageController,
      count: onboardingItems.length,
      effect: WormEffect(
        dotWidth: context.width10,
        dotHeight: context.height10,
        activeDotColor: AppColor.white,
        dotColor: AppColor.redButton,
      ),
    );
  }
}
