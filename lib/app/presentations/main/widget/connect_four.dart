import 'package:connect_four/core/service/ai_service.dart';
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

  int currentPlayer = 1; // 1 = sen, 2 = AI
  bool isGameOver = false;

  // 0 = boş, 1 = kırmızı, 2 = yeşil
  final List<List<int>> board = List.generate(
    rows,
    (_) => List.filled(cols, 0),
  );

  void _dropPiece(int col, int player) {
    for (int row = rows - 1; row >= 0; row--) {
      if (board[row][col] == 0) {
        board[row][col] = player;
        _addPiece(row, col, player);
        break;
      }
    }
  }

  void _addPiece(int row, int col, int player) {
    final targetPosition = Vector2(
      boardPosition.x + col * cellSize + cellSize / 2,
      boardPosition.y + row * cellSize + cellSize / 2,
    );

    final piece = CircleComponent(
      radius: cellSize / 2 - 6,
      position: Vector2(targetPosition.x, boardPosition.y - cellSize * 1.5),
      anchor: Anchor.center,
      paint: Paint()..color = player == 1 ? Colors.red : Colors.green,
    );

    piece.add(MoveEffect.to(targetPosition, EffectController(duration: 0.6)));

    add(piece);
  }

  Future<void> _makeAiMove() async {
    final aiColumn = await AiService.getAiMove(board);
    await Future.delayed(const Duration(milliseconds: 400));
    _dropPiece(aiColumn, 2);
  }

  @override
  Color backgroundColor() => Colors.white;

  @override
  void onTapDown(TapDownEvent event) async {
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

    if (isGameOver) return;

    _dropPiece(col, 1); // SEN

    await Future.delayed(const Duration(milliseconds: 500));

    await _makeAiMove(); // AI
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
