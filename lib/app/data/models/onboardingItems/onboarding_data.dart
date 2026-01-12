import 'package:connect_four/core/extensions/asset_extension.dart';

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
    text: "Connect Four Challenge'a Hoşgeldiniz",
    image: AssetImages.onboarding_1,
  ),
  OnboardingItem(
    text: "Arkadaşlarınla rekabet et",
    image: AssetImages.onboarding_2,
  ),
  OnboardingItem(
    text: "Kazanmaya hazır mısın ?",
    image: AssetImages.onboarding_3,
  ),
];
