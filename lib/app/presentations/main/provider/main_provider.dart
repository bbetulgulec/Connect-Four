import 'package:connect_four/app/data/models/active_game.dart';
import 'package:connect_four/app/presentations/main/widget/award_winning_abs_dialog.dart';
import 'package:connect_four/app/presentations/main/widget/open_dialog_widget.dart';
import 'package:connect_four/core/service/hive_service.dart';
import 'package:connect_four/app/presentations/main/view/main_screen.dart';
import 'package:connect_four/app/presentations/main/widget/connect_four.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MainProvider extends ChangeNotifier {
  late ConnectFour game;
  ActionType? selectedAction;
  bool _isAdShowing = false;

  MainProvider({ActiveGame? initialGame}) {
    _initGame(initialGame);

    game.onSkillFinished = () async {
      if (selectedAction != null) {
        await HiveService.useSkill(selectedAction!);
        completeSkill();
        await game.finishPlayerTurnAfterSkill();
      }
    };

    game.onTurnEnded = () {
      resetAction();
    };
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

  void setupNewGame() {
    // Hive'dan veriyi temizle
    HiveService.deleteData('current_game');

    // ConnectFour oyununu parametresiz (null) başlatarak sıfırla
    _initGame(null);

    // Seçili aksiyonları temizle
    selectedAction = null;

    // Arayüzü haberdar et
    notifyListeners();
  }

  Future<void> selectAction(ActionType action, BuildContext context) async {
    debugPrint("method çalıştı");

    if (_isAdShowing) {
      debugPrint("reklam açık olduğu için return");
      return;
    }

    if (selectedAction == action) {
      completeSkill();
      return;
    }

    int count = HiveService.getSkillCount(action);
    debugPrint("count: $count");

    if (count > 0) {
      selectedAction = action;
      _activateAction(action);
      notifyListeners();
    } else {
      await showDialog(
        context: context,
        builder: (dialogContext) => AwardWinningAbsDialog(
          watch: () async {
            debugPrint("WATCH BASILDI");

            Navigator.of(dialogContext).pop();

            await Future.delayed(const Duration(milliseconds: 200));

            await _showRewardedAd(action);
          },
          close: () => Navigator.of(dialogContext).pop(),
        ),
      );
    }
  }

  Future<void> selectActionLong(ActionType action) async {
    if (_isAdShowing) return;

    _isAdShowing = true;
    notifyListeners();

    _showRewardedAd(action);

    _isAdShowing = false;
    notifyListeners();
  }

  Future<void> consumeSelectedSkill() async {
    if (selectedAction == null) return;

    await HiveService.useSkill(selectedAction!);

    completeSkill();
  }

  void _activateAction(ActionType action) {
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
        _performUndo();

        break;
    }
  }

  Future<void> _performUndo() async {
    if (game.isGameOver) return;

    await game.undoLastMove();

    await HiveService.useSkill(ActionType.undo);

    completeSkill();
  }

  void completeSkill() {
    selectedAction = null;

    game.isSingleExplosion = false;
    game.isRowColumnExplosion = false;
    game.isSwapMode = false;

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

  void resetGame() {
    // Hive'daki aktif oyunu sil
    HiveService.deleteData('current_game');

    // Oyunu sıfırdan oluştur
    game.resetGame(); // ConnectFour içinde yazılmış olmalı

    selectedAction = null;

    notifyListeners();
  }

  int getSkillCount(ActionType action) {
    return HiveService.getSkillCount(action);
  }

  Future<void> _showRewardedAd(ActionType action) async {
    RewardedAd.load(
      adUnitId: "ca-app-pub-9341374865552891/4478536403",
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          ad.show(
            onUserEarnedReward: (ad, reward) async {
              await HiveService.addSkill(action);
              notifyListeners();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint("Ad failed: $error");
        },
      ),
    );
  }

  void checkAndShowTutorial(BuildContext context) {
    final bool hasSeenTutorial =
        HiveService.getData('settings')?['tutorialSeen'] ?? false;

    if (!hasSeenTutorial) {
      // Diyaloğu göster
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            const OpenDialogWidget(initialAction: ActionType.singleExplosion),
      ).then((_) {
        HiveService.saveData('settings', {'tutorialSeen': true});
      });
    }
  }

  void afterDialogClosed() {
    if (!game.isGameOver) return;

    resetAction();
    game.resetGame();
    notifyListeners();
  }
}
