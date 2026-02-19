import 'package:connect_four/app/presentations/main/component/demo_piece.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class SwapDemoGame extends FlameGame {
  late DemoPiece pieceA;
  late DemoPiece pieceB;

  @override
  Future<void> onLoad() async {
    pieceA = DemoPiece(player: 1, position: Vector2(40, 80));

    pieceB = DemoPiece(player: 2, position: Vector2(85, 80));

    add(pieceA);
    add(pieceB);

    Future.delayed(const Duration(milliseconds: 500), () {
      swapPieces(pieceA, pieceB);
    });
  }

  @override
  Color backgroundColor() => Colors.white; // Veya Colors.transparent

  void swapPieces(DemoPiece a, DemoPiece b) {
    final posA = a.position.clone();
    final posB = b.position.clone();

    a.add(
      MoveEffect.to(
        posB,
        EffectController(duration: 1, curve: Curves.easeInOut),
      ),
    );

    b.add(
      MoveEffect.to(
        posA,
        EffectController(duration: 1, curve: Curves.easeInOut),
      ),
    );
  }
}
