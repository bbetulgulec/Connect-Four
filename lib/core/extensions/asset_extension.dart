  enum AssetImages{
  iconText
  }

  extension AssetExtension on AssetImages{
    String get path=>'assets/image/$name.svg';
  }