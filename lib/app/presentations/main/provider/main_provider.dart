import 'package:connect_four/app/data/models/active_game.dart';
import 'package:connect_four/core/service/hive_service.dart';
import 'package:connect_four/app/presentations/main/view/main_screen.dart';
import 'package:connect_four/app/presentations/main/widget/connect_four.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MainProvider extends ChangeNotifier {
  late final ConnectFour game;
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
      resetAction(); // Bu metot selectedAction'ı null yapar ve notifyListeners() çağırır
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

  Future<void> selectAction(ActionType action) async {
    if (_isAdShowing) return;

    if (selectedAction == action) {
      completeSkill();
      return;
    }

    int count = HiveService.getSkillCount(action);

    if (count > 0) {
      selectedAction = action;
      _activateAction(action);
      notifyListeners();
    } else {
      _isAdShowing = true;
      notifyListeners();

      _showRewardedAd(action);
    }
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
        // undo logic
        break;
    }
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

  int getSkillCount(ActionType action) {
    return HiveService.getSkillCount(action);
  }

  void _showRewardedAd(ActionType action) {
    RewardedAd.load(
      adUnitId: "ca-app-pub-8804562918756370/2577297808",
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('Ad loaded');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _isAdShowing = false; // 🔥 KRİTİK
              notifyListeners();
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isAdShowing = false; // 🔥 KRİTİK
              notifyListeners();
              ad.dispose();
            },
          );

          ad.show(
            onUserEarnedReward: (ad, reward) async {
              debugPrint('Reward earned');

              await HiveService.addSkill(action);

              _isAdShowing = false; // 🔥 KRİTİK
              notifyListeners();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Ad failed to load: $error');
          _isAdShowing = false; // 🔥 KRİTİK
          notifyListeners();
        },
      ),
    );
  }
}
