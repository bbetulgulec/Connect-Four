import 'package:equatable/equatable.dart';

class GameProgress extends Equatable {
  final int highScore;
  final int lastScore;
  final int gamesPlayed;
  final int coins;
  final int difficulty;

  const GameProgress({
    required this.highScore,
    required this.lastScore,
    required this.gamesPlayed,
    required this.coins,
    required this.difficulty,
  });

  factory GameProgress.fromJson(Map<String, dynamic> json) {
    return GameProgress(
      highScore: json['highScore'],
      lastScore: json['lastScore'],
      gamesPlayed: json['gamesPlayed'],
      coins: json['coins'],
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'highScore': highScore,
      'lastScore': lastScore,
      'gamesPlayed': gamesPlayed,
      'coins': coins,
      'difficulty': difficulty,
    };
  }

  @override
  List<Object?> get props => [
    highScore,
    lastScore,
    gamesPlayed,
    coins,
    difficulty,
  ];
}
