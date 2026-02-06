import 'package:equatable/equatable.dart';

class ActiveGame extends Equatable {
  final List<List<int>> board;
  final int currentPlayer;
  final bool isPlayerTurn;
  final bool isGameOver;
  final int score;

  const ActiveGame({
    required this.board,
    required this.currentPlayer,
    required this.isPlayerTurn,
    required this.isGameOver,
    required this.score,
  });

  factory ActiveGame.fromJson(Map<String, dynamic> json) {
    return ActiveGame(
      board: (json['board'] as List).map((e) => List<int>.from(e)).toList(),
      currentPlayer: json['currentPlayer'] as int,
      isPlayerTurn: json['isPlayerTurn'] as bool,
      isGameOver: json['isGameOver'] as bool,
      score: json['score'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'board': board,
      'currentPlayer': currentPlayer,
      'isPlayerTurn': isPlayerTurn,
      'isGameOver': isGameOver,
      'score': score,
    };
  }

  @override
  List<Object?> get props => [
    board,
    currentPlayer,
    isPlayerTurn,
    isGameOver,
    score,
  ];
}
