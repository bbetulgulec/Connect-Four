enum AssetImages { background }

extension AssetExtension on AssetImages {
  String get path => 'assets/image/$name.png';
}
