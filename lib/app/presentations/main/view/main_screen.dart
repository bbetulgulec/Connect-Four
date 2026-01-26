import 'package:connect_four/app/data/hive/game_storage.dart';
import 'package:connect_four/app/presentations/main/widget/connect_four.dart';
import 'package:connect_four/app/presentations/main/widget/icon_widget.dart';
import 'package:connect_four/app/presentations/main/widget/scor_text_widget.dart';
import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:connect_four/app/presentations/main/widget/dialog_widget.dart';

enum ActionType { singleExplosion, rowColumnExplosion, swap, undo }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ConnectFour game = ConnectFour();
  final GameStorage storage = GameStorage();

  ActionType? selectedAction;

  void selectAction(ActionType action) {
    setState(() {
      selectedAction = action;
    });

    /// Oyun modları
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
  }

  double _opacity(ActionType action) {
    if (selectedAction == null) return 1.0;
    return selectedAction == action ? 1.0 : 0.4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.image.path(AssetType.png)),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /// SCORE BAR
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ScorText(title: 'SCORE', notifier: game.scoreNotifier),
                    ScorText(
                      title: 'BEST',
                      notifier: storage.bestScoreNotifier,
                    ),
                  ],
                ),
              ),

              /// GAME
              AspectRatio(
                aspectRatio: 1,

                child: GameWidget<ConnectFour>(
                  game: game,
                  overlayBuilderMap: {
                    'WinOverlay': (_, game) => DialogWidget(
                      result: GameResult.win,
                      onPlayAgain: () {
                        game.overlays.remove('WinOverlay');
                        game.resetGame();
                        setState(() => selectedAction = null);
                      },
                    ),
                    'LoseOverlay': (_, game) => DialogWidget(
                      result: GameResult.lose,
                      onPlayAgain: () {
                        game.overlays.remove('LoseOverlay');
                        game.resetGame();
                        setState(() => selectedAction = null);
                      },
                    ),
                    'NoSpace': (_, game) => DialogWidget(
                      result: GameResult.noSpace,
                      onPlayAgain: () {
                        game.resetGame();
                        setState(() => selectedAction = null);
                      },
                    ),
                  },
                ),
              ),

              /// ACTION BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Opacity(
                    opacity: _opacity(ActionType.singleExplosion),
                    child: IconWidget(
                      iconPath: AssetImages.block_1explosion.path(
                        AssetType.png,
                      ),
                      onTap: () => selectAction(ActionType.singleExplosion),
                    ),
                  ),
                  Opacity(
                    opacity: _opacity(ActionType.rowColumnExplosion),
                    child: IconWidget(
                      iconPath: AssetImages.column_1row_1deletion.path(
                        AssetType.png,
                      ),
                      onTap: () => selectAction(ActionType.rowColumnExplosion),
                    ),
                  ),
                  Opacity(
                    opacity: _opacity(ActionType.swap),
                    child: IconWidget(
                      iconPath: AssetImages.swap.path(AssetType.png),
                      onTap: () => selectAction(ActionType.swap),
                    ),
                  ),
                  Opacity(
                    opacity: _opacity(ActionType.undo),
                    child: IconWidget(
                      iconPath: AssetImages.undo_1move.path(AssetType.png),
                      onTap: () => selectAction(ActionType.undo),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
