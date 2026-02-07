import 'package:connect_four/app/presentations/login/view/login_view.dart';
import 'package:connect_four/app/presentations/onboarding/provider/onboarding_provider.dart';
import 'package:connect_four/core/helper/nav_helper/navigation_helper.dart';
import 'package:flutter/material.dart';

import 'package:connect_four/app/common/widget/text_title.dart';
import 'package:connect_four/app/presentations/onboarding/widget/elevated_button_widget.dart';
import 'package:connect_four/app/presentations/onboarding/widget/page_view_dots.dart';
import 'package:connect_four/app/data/models/onboardingItems/onboarding_data.dart';
import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:provider/provider.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          Positioned.fill(
            child: Image.asset(
              AssetImages.image.path(AssetType.png),
              fit: BoxFit.cover,
            ),
          ),

          /// PAGE VIEW
          PageView.builder(
            controller: provider.pageController,
            itemCount: onboardingItems.length,
            itemBuilder: (context, index) {
              final item = onboardingItems[index];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextTitle(title: item.text),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset(
                        item.image.path(AssetType.png),
                        fit: BoxFit.contain, // ← önemli
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          /// BOTTOM CONTROLS
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                PageViewDots(pageController: provider.pageController),
                const SizedBox(height: 60),
                ElevatedButtonWidget(
                  onPressed: () {
                    provider.nextPage(() {
                      Navigation.pushReplace(page: const LoginView());
                    });
                  },
                  text: provider.currentPage == onboardingItems.length - 1
                      ? "Başlayalım"
                      : "Sonraki",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
