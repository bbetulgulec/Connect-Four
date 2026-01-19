enum AssetImages {
  background,
  onboarding_1,
  image,
  onboarding_2,
  onboarding_3,
  block_1explosion,
  swap,
  undo_1move,
  column_1row_1deletion,
}

enum AssetType { png, svg }

extension AssetExtension on AssetImages {
  String path(AssetType type) {
    return 'assets/image/$name.${type.name}';
  }
}
