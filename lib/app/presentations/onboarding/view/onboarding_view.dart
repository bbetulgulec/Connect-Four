import 'package:connect_four/app/presentations/login/view/login_view.dart';
import 'package:connect_four/app/presentations/onboarding/provider/onboarding_provider.dart';
import 'package:connect_four/core/extensions/build_context_extensions.dart';
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
                  SizedBox(
                    width: context.width300,
                    height: context.height300,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset(
                        item.image.path(AssetType.png),
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.width12),
                    child: TextTitle(title: item.text),
                  ),
                ],
              );
            },
          ),

          /// BOTTOM CONTROLS
          Padding(
            padding: EdgeInsets.only(top: context.height300 * 2.7),
            child: Column(
              children: [
                PageViewDots(pageController: provider.pageController),
                SizedBox(height: context.height12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.width20),
                  child: ElevatedButtonWidget(
                    onPressed: () {
                      provider.nextPage(() {
                        Navigation.pushReplace(page: const LoginView());
                      });
                    },
                    text: "Devam Et",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
