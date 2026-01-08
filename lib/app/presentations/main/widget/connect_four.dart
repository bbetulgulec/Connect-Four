import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ConnectFour extends FlameGame with TapCallbacks {
  static const int rows = 8;
  static const int cols = 6;

  late double cellSize;
  late Vector2 boardPosition;

  // 0 = boş, 1 = kırmızı, 2 = yeşil
  final List<List<int>> board = List.generate(
    rows,
    (_) => List.filled(cols, 0),
  );

  void _dropPiece(int col) {
    // alttan yukarı doğru boş hücre ara
    for (int row = rows - 1; row >= 0; row--) {
      if (board[row][col] == 0) {
        board[row][col] = 1; // kırmızı

        _addPiece(row, col);
        break;
      }
    }
  }

  void _addPiece(int row, int col) {
    final targetPosition = Vector2(
      boardPosition.x + col * cellSize + cellSize / 2,
      boardPosition.y + row * cellSize + cellSize / 2,
    );

    final piece = CircleComponent(
      radius: cellSize / 2 - 6,
      position: Vector2(targetPosition.x, boardPosition.y - cellSize * 1.5),
      scale: Vector2.all(1.3),
      anchor: Anchor.center,
      paint: Paint()..color = Colors.red,
    );

    piece.add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.4), EffectController(duration: 0.2)),
        MoveEffect.to(targetPosition, EffectController(duration: 0.8)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.4)),
      ]),
    );

    add(piece);
  }

  @override
  Color backgroundColor() => Colors.white;

  @override
  void onTapDown(TapDownEvent event) {
    final tap = event.localPosition;

    // Board dışıysa çık
    if (tap.x < boardPosition.x ||
        tap.x > boardPosition.x + cellSize * cols ||
        tap.y < boardPosition.y ||
        tap.y > boardPosition.y + cellSize * rows) {
      return;
    }

    // Hangi kolon?
    final int col = ((tap.x - boardPosition.x) / cellSize).floor();

    _dropPiece(col);
  }

  @override
  Future<void> onLoad() async {
    //  hücre boyutunu ekran genişliğine göre ayarla
    cellSize = size.x / cols;

    final boardWidth = cellSize * cols;
    final boardHeight = cellSize * rows;

    //  board'u tam ortala
    boardPosition = Vector2(
      (size.x - boardWidth) / 2,
      (size.y - boardHeight) / 2,
    );

    //  Board
    add(
      RectangleComponent(
        size: Vector2(boardWidth, boardHeight),
        position: boardPosition,
        paint: Paint()..color = Colors.blue,
      ),
    );

    //  Delikler
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = boardPosition.x + col * cellSize + cellSize / 2;
        final y = boardPosition.y + row * cellSize + cellSize / 2;

        add(
          CircleComponent(
            radius: cellSize / 2 - 4,
            position: Vector2(x, y),
            anchor: Anchor.center,
            paint: Paint()..color = Colors.white,
          ),
        );
      }
    }
  }
}
