import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'game_progress.dart';

class GameStorage {
  static const _boxName = 'game';
  static const _key = 'progress';

  final ValueNotifier<int> bestScoreNotifier = ValueNotifier<int>(0);

  Box<GameProgress> get _box => Hive.box<GameProgress>(_boxName);

  GameStorage() {
    // 📌 App açılırken Hive’daki best score UI’ya ver
    bestScoreNotifier.value = progress.highScore;
  }
  GameProgress get _data {
    if (!_box.containsKey(_key)) {
      final initial = GameProgress(
        highScore: 0,
        lastScore: 0,
        gamesPlayed: 0,
        coins: 0,
        difficulty: 1,
      );
      _box.put(_key, initial);
      return initial;
    }
    return _box.get(_key)!;
  }

  /// Oyun bittiğinde çağrılacak
  void onGameFinished({required bool isWin, required int score}) {
    final data = _data;

    data.lastScore = score;
    data.gamesPlayed++;

    if (isWin) {
      //  İlk kez kazanıyorsa veya daha az atışla kazandıysa
      if (data.highScore == 0 || score < data.highScore) {
        data.highScore = score;
        bestScoreNotifier.value = score; // UI güncelle
      }

      data.coins += 10;
    }

    data.save();
  }

  GameProgress get progress => _data;
}
