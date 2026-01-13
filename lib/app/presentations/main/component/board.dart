import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class Board extends Component {
  final int rows;
  final int cols;
  final double cellSize;
  final Vector2 position;

  Board({
    required this.rows,
    required this.cols,
    required this.cellSize,
    required this.position,
  });

  @override
  Future<void> onLoad() async {
    final boardWidth = cellSize * cols;
    final boardHeight = cellSize * rows;

    // 1. Ana Arka Plan Glow (Bütün boardun arkasındaki hafif parlama)
    add(
      RectangleComponent(
        size: Vector2(boardWidth + 20, boardHeight + 20),
        position: position - Vector2(10, 10),
        paint: Paint()
          ..color = Colors.redAccent.withAlpha(90)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
      ),
    );

    // 2. Grid Döngüsü (Kare hücreler)
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = position.x + col * cellSize;
        final y = position.y + row * cellSize;

        // Hücre dış çizgi
        add(
          RectangleComponent(
            position: Vector2(x, y),
            size: Vector2(cellSize, cellSize),
            paint: Paint()
              ..color = Colors.white
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1,
          ),
        );

        // Hücrenin içindeki küçük dekoratif kare
        final innerPadding = cellSize * 0.15;
        add(
          RectangleComponent(
            position: Vector2(x + innerPadding, y + innerPadding),
            size: Vector2(
              cellSize - (innerPadding * 2),
              cellSize - (innerPadding * 2),
            ),
            paint: Paint()
              ..color = const Color.fromARGB(255, 255, 255, 255).withAlpha(20)
              ..style = PaintingStyle.fill,
          ),
        );

        // İç karenin parlayan ince kenarlığı
        add(
          RectangleComponent(
            position: Vector2(x + innerPadding, y + innerPadding),
            size: Vector2(
              cellSize - (innerPadding * 2),
              cellSize - (innerPadding * 2),
            ),
            paint: Paint()
              ..color = const Color.fromARGB(255, 255, 255, 255).withAlpha(30)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 0.5
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
          ),
        );
      }
    }

    // 3. En Dış Keskin Çerçeve
    add(
      RectangleComponent(
        size: Vector2(boardWidth, boardHeight),
        position: position,
        paint: Paint()
          ..color = Colors.white.withAlpha(70)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      ),
    );
  }
}
