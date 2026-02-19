import 'package:connect_four/app/presentations/main/widget/banner_add_widget.dart';
import 'package:connect_four/app/presentations/main/widget/tabbar_widget.dart';
import 'package:connect_four/core/service/hive_service.dart';
import 'package:connect_four/app/presentations/main/provider/main_provider.dart';
import 'package:connect_four/app/presentations/main/widget/connect_four.dart';
import 'package:connect_four/app/presentations/main/widget/icon_widget.dart';
import 'package:connect_four/app/presentations/main/widget/scor_text_widget.dart';
import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:connect_four/app/presentations/main/widget/dialog_widget.dart';
import 'package:provider/provider.dart';

enum ActionType { singleExplosion, rowColumnExplosion, swap, undo }

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MainProvider>();
    final game = provider.game;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.image.path(AssetType.png)),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 310),
              child: Align(
                alignment: Alignment.topRight,
                child: TabbarWidget(),
              ),
            ),

            /// SCORE BAR
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ScorText(title: 'SCORE', notifier: game.scoreNotifier),
                  ScorText(
                    title: 'BEST',
                    notifier: ValueNotifier<int>(
                      HiveService.getData('game_progress')?['highScore'] ?? 0,
                    ),
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
                      provider.resetAction();
                    },
                  ),
                  'LoseOverlay': (_, game) => DialogWidget(
                    result: GameResult.lose,
                    onPlayAgain: () {
                      game.overlays.remove('LoseOverlay');
                      game.resetGame();
                      provider.resetAction();
                    },
                  ),
                  'NoSpace': (_, game) => DialogWidget(
                    result: GameResult.noSpace,
                    onPlayAgain: () {
                      game.resetGame();
                      provider.resetAction();
                    },
                  ),
                },
              ),
            ),

            /// ACTION BAR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ActionType.values.map((action) {
                return Opacity(
                  opacity: provider.opacity(action),
                  child: IconWidget(
                    iconPath: _iconPath(action),
                    badgeCount: provider.getSkillCount(action),
                    onTap: () => provider.selectAction(action),
                    onLongComplete: () => provider.selectAction(action),
                  ),
                );
              }).toList(),
            ),
            BannerAdWidget(),
          ],
        ),
      ),
    );
  }

  String _iconPath(ActionType action) {
    switch (action) {
      case ActionType.singleExplosion:
        return AssetImages.block_1explosion.path(AssetType.png);
      case ActionType.rowColumnExplosion:
        return AssetImages.column_1row_1deletion.path(AssetType.png);
      case ActionType.swap:
        return AssetImages.swap.path(AssetType.png);
      case ActionType.undo:
        return AssetImages.undo_1move.path(AssetType.png);
    }
  }
}
