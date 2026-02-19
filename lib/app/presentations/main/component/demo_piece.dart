import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DemoPiece extends PositionComponent {
  final int player;
  int? row;

  DemoPiece({required Vector2 position, required this.player, this.row}) {
    this.position = position;
    size = Vector2.all(40);
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = player == 1 ? Colors.redAccent : Colors.greenAccent;

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
  }
}
