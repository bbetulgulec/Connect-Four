import 'package:connect_four/app/presentations/main/component/demo_piece.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class RowColumnExplosionDemoGame extends FlameGame {
  final List<DemoPiece> pieces = [];
  final double cellSize = 50; 

  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onLoad() async {
    _setup();
    camera.viewfinder.position = Vector2(cellSize, cellSize);
    camera.viewfinder.anchor = Anchor.center;
  }

  void _setup() {
    world.removeAll(world.children.whereType<DemoPiece>());
    pieces.clear();

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        int player = (row == 1 && col == 1) ? 1 : 2;

        // Taşları 0,0 merkezli bir koordinat sistemine diziyoruz
        final piece = DemoPiece(
          player: player,
          position: Vector2(col * cellSize, row * cellSize),
        );

        world.add(piece);
        pieces.add(piece);
      }
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (isMounted) _explodeRowColumn();
    });
  }

  void _explodeRowColumn() {
    for (var piece in List.from(pieces)) {
      // Pozisyonları hücre boyutuna bölerek hangi satır/sütun olduğunu buluyoruz
      int pCol = (piece.position.x / cellSize).round();
      int pRow = (piece.position.y / cellSize).round();

      if (pRow == 1 || pCol == 1) {
        _applyExplosionEffect(piece);
      }
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (isMounted) _setup();
    });
  }

  void _applyExplosionEffect(DemoPiece piece) {
    piece.add(
      ScaleEffect.to(
        Vector2.all(1.2),
        EffectController(duration: 0.1),
        onComplete: () {
          piece.add(
            ScaleEffect.to(
              Vector2.zero(),
              EffectController(duration: 0.2, curve: Curves.easeIn),
              onComplete: () {
                piece.removeFromParent();
                pieces.remove(piece);
              },
            ),
          );
        },
      ),
    );
  }
}
