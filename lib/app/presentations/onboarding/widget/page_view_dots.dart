import 'package:connect_four/app/data/models/onboardingItems/onboarding_data.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageViewDots extends StatelessWidget {
  const PageViewDots({super.key, required PageController pageController}) : _pageController = pageController;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: _pageController,
      count: onboardingItems.length,
      effect: WormEffect(
        dotWidth: 10,
        dotHeight: 10,
        activeDotColor: Colors.white,
        dotColor: Colors.pink,
      ),
    );
  }
}