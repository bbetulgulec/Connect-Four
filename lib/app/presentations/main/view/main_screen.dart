import 'package:connect_four/app/presentations/main/widget/connect_four.dart';
import 'package:connect_four/app/presentations/main/widget/scor_text_widget.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //  SCORE ALANI (SABİT)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [ScorText(), ScorText()],
            ),
          ),

          //  OYUN ALANI (KALAN ALANI KAPLAR)
          Expanded(child: GameWidget(game: ConnectFour())),
        ],
      ),
    );
  }
}
