import 'package:connect_four/app/data/models/active_game.dart';
import 'package:connect_four/core/service/hive_service.dart';
import 'package:connect_four/app/presentations/main/view/main_screen.dart';
import 'package:connect_four/app/presentations/main/widget/connect_four.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  late final ConnectFour game;
  ActionType? selectedAction;

  MainProvider({ActiveGame? initialGame}) {
    _initGame(initialGame);
  }

  void _initGame(ActiveGame? initialGame) {
    final savedMap = initialGame == null
        ? HiveService.getData('current_game')
        : null;

    final startingGame =
        initialGame ??
        (savedMap != null ? ActiveGame.fromJson(savedMap) : null);

    game = ConnectFour(initialGame: startingGame);
  }

  void selectAction(ActionType action) {
    selectedAction = action;

    game.isSingleExplosion = false;
    game.isRowColumnExplosion = false;
    game.isSwapMode = false;

    switch (action) {
      case ActionType.singleExplosion:
        game.isSingleExplosion = true;
        break;

      case ActionType.rowColumnExplosion:
        game.isRowColumnExplosion = true;
        break;

      case ActionType.swap:
        game.isSwapMode = true;
        game.firstSelectedPiece = null;
        break;

      case ActionType.undo:
        game.isRowColumnExplosion = true;
        break;
    }

    notifyListeners();
  }

  double opacity(ActionType action) {
    if (selectedAction == null) return 1.0;
    return selectedAction == action ? 1.0 : 0.4;
  }

  void resetAction() {
    selectedAction = null;
    notifyListeners();
  }

  void resetGame(BuildContext context) {
    // Hive'daki aktif oyunu sil
    HiveService.deleteData('current_game');

    // Oyunu sıfırdan oluştur
    game.resetGame(); // ConnectFour içinde yazılmış olmalı

    selectedAction = null;

    notifyListeners();

    // Dialog kapat
    Navigator.of(context).pop();

    // Ana ekrana temiz şekilde dön
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }
}
