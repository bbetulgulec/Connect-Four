import 'package:hive/hive.dart';

part 'game_progress.g.dart';

@HiveType(typeId: 0)
class GameProgress extends HiveObject {
  @HiveField(0)
  int highScore;

  @HiveField(1)
  int lastScore;

  @HiveField(2)
  int gamesPlayed;

  @HiveField(3)
  int coins;

  @HiveField(4)
  int difficulty;

  GameProgress({
    required this.highScore,
    required this.lastScore,
    required this.gamesPlayed,
    required this.coins,
    required this.difficulty,
  });
}
