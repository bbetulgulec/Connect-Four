import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class DialogWidget extends StatefulWidget {
  final bool isWin;
  final int player1Score;
  final int player2Score;
  final VoidCallback onPlayAgain;

  const DialogWidget({
    super.key,
    required this.isWin,
    required this.player1Score,
    required this.player2Score,
    required this.onPlayAgain,
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

    // Gecikmeyle başlatmak bazen daha güvenli olur
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isWin) _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  // Yıldız şekli fonksiyonu (senin verdiğin – ufak düzeltmelerle)
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

    path.moveTo(size.width, halfWidth); // başlangıç noktası (sağda)

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
    final isWin = widget.isWin;
    final buttonColor = isWin ? Colors.green : Colors.redAccent;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Stack(
        clipBehavior: Clip.none, // confetti taşmasın diye
        children: [
          // Ana kart
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360, maxHeight: 420),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0D1B2A).withOpacity(0.95),
                      const Color(0xFF0D1B2A).withOpacity(0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: isWin ? Colors.greenAccent : Colors.redAccent,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isWin ? Colors.greenAccent : Colors.redAccent)
                          .withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      isWin ? "YOU WIN!" : "GAME OVER",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: isWin ? Colors.greenAccent : Colors.redAccent,
                        shadows: [
                          Shadow(
                            blurRadius: 20,
                            color: isWin ? Colors.green : Colors.red,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isWin
                          ? "Congratulations!\nYou connected four."
                          : "Better luck next time.",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: widget.onPlayAgain,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 10,
                          shadowColor: buttonColor.withOpacity(0.6),
                        ),
                        child: Text(
                          isWin ? "PLAY AGAIN" : "TRY AGAIN",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
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
          if (isWin)
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
