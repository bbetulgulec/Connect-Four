import 'package:connect_four/app/data/hive/game_storage.dart';
import 'package:connect_four/app/presentations/main/widget/connect_four.dart';
import 'package:connect_four/app/presentations/main/widget/icon_widget.dart';
import 'package:connect_four/app/presentations/main/widget/scor_text_widget.dart';
import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:connect_four/core/extensions/build_context_extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:connect_four/app/presentations/main/widget/dialog_widget.dart'; // ← DialogWidget'ı import et

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final game = ConnectFour();
  final storage = GameStorage();

  @override
  Widget build(BuildContext context) {
    final storage = GameStorage();

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
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

              SizedBox(
                height:
                    MediaQuery.of(context).size.height *
                    0.60, // ← %60 dene, beğenmezsen 0.55 veya 0.65 yap
                width: MediaQuery.of(context).size.width * 0.90,
                child: GameWidget<ConnectFour>(
                  game: game,
                  overlayBuilderMap: {
                    'WinOverlay': (BuildContext context, ConnectFour game) {
                      return DialogWidget(
                        isWin: true,
                        player1Score: game.player1Score,
                        player2Score: game.player2Score,
                        onPlayAgain: () {
                          game.overlays.remove('WinOverlay');
                          game.resetGame();
                        },
                      );
                    },
                    'LoseOverlay': (BuildContext context, ConnectFour game) {
                      return DialogWidget(
                        isWin: false,
                        player1Score: game.player1Score,
                        player2Score: game.player2Score,
                        onPlayAgain: () {
                          game.overlays.remove('LoseOverlay');
                          game.resetGame();
                        },
                      );
                    },
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconWidget(
                    iconPath: AssetImages.block_1explosion.path(AssetType.png),
                  ),
                  IconWidget(
                    iconPath: AssetImages.column_1row_1deletion.path(
                      AssetType.png,
                    ),
                  ),
                  IconWidget(iconPath: AssetImages.swap.path(AssetType.png)),
                  IconWidget(
                    iconPath: AssetImages.undo_1move.path(AssetType.png),
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
