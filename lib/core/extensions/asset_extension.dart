enum AssetImages { iconText, background }

extension AssetExtension on AssetImages {
  String get path => 'assets/image/$name.svg';
}
