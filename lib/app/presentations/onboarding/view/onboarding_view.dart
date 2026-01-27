import 'package:connect_four/app/presentations/login/view/login_view.dart';
import 'package:connect_four/core/helper/nav_helper/navigation_helper.dart';
import 'package:flutter/material.dart';

import 'package:connect_four/app/common/widget/text_title.dart';
import 'package:connect_four/app/presentations/onboarding/widget/elevated_button_widget.dart';
import 'package:connect_four/app/presentations/onboarding/widget/page_view_dots.dart';
import 'package:connect_four/app/data/models/onboardingItems/onboarding_data.dart';
import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:hive/hive.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  void nextPage() async {
    if (_pageController.page! < onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 🔴 BURASI EN KRİTİK SATIR
      final onboardingBox = Hive.box<bool>('onboarding');
      await onboardingBox.put('shown', true);

      Navigation.pushReplace(page: const LoginView());
    }
  }

  @override
  void initState() {
    super.initState();

    // PageView sayfa değişimini dinle
    _pageController.addListener(() {
      int newPage = _pageController.page!.round();
      if (currentPage != newPage) {
        setState(() {
          currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            controller: _pageController,
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
                PageViewDots(pageController: _pageController),
                const SizedBox(height: 60),
                ElevatedButtonWidget(
                  onPressed: nextPage,
                  text:
                      (_pageController.hasClients &&
                          _pageController.page == onboardingItems.length - 1)
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
