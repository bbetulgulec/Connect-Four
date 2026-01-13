import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class Piece extends PositionComponent {
  Piece({
    required this.player,
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

    // Ana taş rengi (dış katman)
    add(
      CircleComponent(
        radius: (cellSize - 12) / 2,
        position: size / 2,
        anchor: Anchor.center,
        paint: Paint()..color = baseColor,
      ),
    );

    // İç gölge / karanlık katman (derinlik verir)
    add(
      CircleComponent(
        radius: (cellSize - 12) / 2 * 0.7,
        position: size / 2,
        anchor: Anchor.center,
        paint: Paint()..color = shadowColor,
      ),
    );

    // Üst parlak katman (highlight / parlama efekti)
    add(
      CircleComponent(
        radius: (cellSize - 12) / 2 * 0.65,
        position: size / 2,
        anchor: Anchor.center,
        paint: Paint()
          ..color = baseColor.withAlpha(90), // hafif saydam parlaklık
      ),
    );

    // Düşme animasyonu (bounceOut ile zıplama efekti)
    add(
      MoveEffect.to(
        targetPosition,
        EffectController(duration: 0.6, curve: Curves.bounceOut),
      ),
    );
  }

  final int player;
}
