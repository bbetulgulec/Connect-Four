import 'package:connect_four/app/presentations/main/widget/connect_four.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Piece extends PositionComponent with TapCallbacks {
  final int player;
  final int col;
  final int row;
  final bool isEnemy;
  final ConnectFour game;
  Piece({
    required this.player,
    required this.col,
    required this.row,
    required this.isEnemy,
    required this.game,
    required Vector2 startPosition,
    required Vector2 targetPosition,
    required double cellSize,
  }) : super(
         position: startPosition,
         size: Vector2.all(cellSize - 12),
         anchor: Anchor.center,
       ) {
    final baseColor = player == 1 ? Colors.redAccent : Colors.greenAccent;
    final shadowColor = player == 1 ? Colors.red : Colors.green;

    add(
      CircleComponent(
        radius: (cellSize - 12) / 2,
        position: size / 2,
        anchor: Anchor.center,
        paint: Paint()..color = baseColor,
      ),
    );

    add(
      CircleComponent(
        radius: (cellSize - 12) / 2 * 0.7,
        position: size / 2,
        anchor: Anchor.center,
        paint: Paint()..color = shadowColor,
      ),
    );

    add(
      CircleComponent(
        radius: (cellSize - 12) / 2 * 0.65,
        position: size / 2,
        anchor: Anchor.center,
        paint: Paint()..color = baseColor.withAlpha(90),
      ),
    );

    add(
      MoveEffect.to(
        targetPosition,
        EffectController(duration: 0.6, curve: Curves.bounceOut),
      ),
    );
  }

  void breakPiece() {
    removeFromParent();
  }

  void breakAllRowAndColumn() {

      final targetCol = col;
      final targetRow = row;
      for (final piece in game.pieces) {
        if (piece.col == targetCol || piece.row == targetRow) {
          piece.breakPiece();
        }
      }
      game.isExplosionMode = false; // sadece 1 kez kır
    
  }

  @override
bool onTapDown(TapDownEvent event) {
  if (isEnemy) {
    if (game.isSingleExplosion) {
      breakPiece();
      game.isSingleExplosion = false; // sadece 1 kez kır
    } else if (game.isRowColumnExplosion) {
      breakAllRowAndColumn();
      game.isRowColumnExplosion = false; // sadece 1 kez kır
    }
  }
  return true;
}

}
