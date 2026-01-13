import 'package:connect_four/app/presentations/main/widget/connect_four.dart';
import 'package:connect_four/app/presentations/main/widget/scor_text_widget.dart';
import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:connect_four/app/presentations/main/widget/dialog_widget.dart'; // ← DialogWidget'ı import et

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = ConnectFour(); // ← game instance'ı burada yarat

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.image.path(.png)),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [ScorText(), ScorText()],
              ),
            ),

            Expanded(
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
          ],
        ),
      ),
    );
  }
}
