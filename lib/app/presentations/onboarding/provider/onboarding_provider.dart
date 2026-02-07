import 'package:flutter/material.dart';
import 'package:connect_four/core/service/hive_service.dart';
import 'package:connect_four/app/data/models/onboardingItems/onboarding_data.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  // PageView dinleyicisi için
  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  Future<void> nextPage(VoidCallback onFinish) async {
    if (pageController.page! < onboardingItems.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Veriyi kaydet
      await HiveService.saveData('onboarding', {'shown': true});

      // "Benim işim bitti, şimdi ne yapacaksan yap" (Navigasyon vs.)
      onFinish();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
