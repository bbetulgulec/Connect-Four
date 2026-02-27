import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:connect_four/core/localization/app_localization.dart';

class OnboardingItem {
  final String text;
  final AssetImages image;

  const OnboardingItem({
    required this.text,
    required this.image,
  });
}
final List<OnboardingItem> onboardingItems = [
  OnboardingItem(
    text: AppLocalization.translate("onboardingWelcome"),
    image: AssetImages.onboarding_1,
  ),
  OnboardingItem(
    text: AppLocalization.translate("onboardingFriendFight"),
    image: AssetImages.onboarding_2,
  ),
  OnboardingItem(
    text: AppLocalization.translate("onboardingReady"),
    image: AssetImages.onboarding_3,
  ),
];
