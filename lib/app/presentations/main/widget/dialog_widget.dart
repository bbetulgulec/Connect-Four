import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

enum GameResult { win, lose, noSpace }

class DialogWidget extends StatefulWidget {
  final GameResult result;
  final VoidCallback onPlayAgain;

  const DialogWidget({
    super.key,

    required this.onPlayAgain,
    required this.result,
  });

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 6),
    );

    if (widget.result == GameResult.win) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (math.pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);

    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
        halfWidth + externalRadius * math.cos(step),
        halfWidth + externalRadius * math.sin(step),
      );
      path.lineTo(
        halfWidth + internalRadius * math.cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * math.sin(step + halfDegreesPerStep),
      );
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor;
    String title;
    String subtitle;
    String buttonText;

    switch (widget.result) {
      case GameResult.win:
        mainColor = Colors.greenAccent;
        title = "YOU WIN!";
        subtitle = "Master of the tiles!\nYou dominated the board.";
        buttonText = "PLAY AGAIN";
        break;
      case GameResult.lose:
        mainColor = Colors.redAccent;
        title = "GAME OVER";
        subtitle = "Tactics failed this time.\nTry a new strategy!";
        buttonText = "TRY AGAIN";
        break;
      case GameResult.noSpace:
        mainColor = Colors.orangeAccent;
        title = "NO SPACE!";
        subtitle = "The board is full.\nIt's a tactical deadlock!";
        buttonText = "RESET BOARD";
        break;
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Stack(
        clipBehavior: Clip.none, // confetti taşmasın diye
        children: [
          // Ana kart
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340, maxHeight: 400),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0D1B2A).withAlpha(95),
                      const Color(0xFF0D1B2A).withAlpha(85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: mainColor.withAlpha(50), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withAlpha(20),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        shadows: [Shadow(color: mainColor, blurRadius: 15)],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: widget.onPlayAgain,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 10,
                            shadowColor: mainColor.withAlpha(60),
                          ),
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          // Confetti – tam ekran kaplasın diye Positioned.fill
          if (widget.result == GameResult.win)
            Positioned.fill(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.purple,
                  Colors.orange,
                  Colors.pink,
                ],
                numberOfParticles: 150, // daha yoğun olsun
                maxBlastForce: 70,
                minBlastForce: 25,
                emissionFrequency: 0.02, // hızlı patlama
                gravity: 0.15, // hafif yavaş düşsün
                createParticlePath: drawStar, //
              ),
            ),
        ],
      ),
    );
  }
}
