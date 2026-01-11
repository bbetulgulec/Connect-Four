enum AssetImages { background, onboarding_1 }

extension AssetExtension on AssetImages {
  String get path => 'assets/image/$name.png';
}
