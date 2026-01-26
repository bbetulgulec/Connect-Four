import 'package:connect_four/app/presentations/main/widget/connect_four.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Piece extends PositionComponent with TapCallbacks {
  final int player;
  int col;
  int row;
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
    game.board[row][col] = 0;

    removeFromParent();

    game.pieces.remove(this);

    removeFromParent();

    game.applyGravity();
  }

  void explode({VoidCallback? onComplete}) {
    // 🔥 board datasını hemen temizle
    game.board[row][col] = 0;
    game.pieces.remove(this);

    // 💥 önce büyü
    add(
      ScaleEffect.to(
        Vector2.all(1.4),
        EffectController(duration: 0.12, curve: Curves.easeOut),
        onComplete: () {
          // 💨 sonra küçülerek yok ol
          add(
            ScaleEffect.to(
              Vector2.zero(),
              EffectController(duration: 0.18, curve: Curves.easeIn),
              onComplete: () {
                removeFromParent();
                onComplete?.call(); // ⬇️ EN KRİTİK SATIR
              },
            ),
          );
        },
      ),
    );
  }

  void breakAllRowAndColumn() {
    final targetCol = col;
    final targetRow = row;

    final toRemove = game.pieces.where((p) {
      return p.col == targetCol || p.row == targetRow;
    }).toList();

    int finished = 0;

    for (final piece in toRemove) {
      piece.explode(
        onComplete: () {
          finished++;

          // 🔽 TÜM PATLAMALAR BİTTİ
          if (finished == toRemove.length) {
            game.applyGravity(); // ✅ 1 KERE
          }
        },
      );
    }

    game.isRowColumnExplosion = false;
  }

  void _handleSwap() {
    // 1️⃣ İlk taş seçimi
    if (game.firstSelectedPiece == null) {
      game.firstSelectedPiece = this;

      add(
        ScaleEffect.to(
          Vector2.all(1.25),
          EffectController(duration: 0.2, curve: Curves.easeOutBack),
        ),
      );
      return;
    }

    final first = game.firstSelectedPiece!;

    // 2️⃣ Aynı taşa basıldıysa iptal
    if (first == this) {
      first.add(
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.15)),
      );
      game.firstSelectedPiece = null;
      game.isSwapMode = false;
      return;
    }

    // 3️⃣ SADECE YAN KOMŞU KONTROLÜ 🔒
    final int rowDiff = (first.row - row).abs();
    final int colDiff = (first.col - col).abs();

    final bool isAdjacent = (rowDiff + colDiff) == 1;

    if (!isAdjacent) {
      // ❌ Yan değil → iptal + eski boyuta dön
      first.add(
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.15)),
      );

      game.firstSelectedPiece = null;
      game.isSwapMode = false;
      return;
    }

    // 4️⃣ YAN KOMŞU → SWAP 🔄
    game.swapPieces(first, this);

    game.firstSelectedPiece = null;
    game.isSwapMode = false;
  }

  @override
  bool onTapDown(TapDownEvent event) {
    // 🔁 1️⃣ SWAP MODU HER ŞEYDEN ÖNCE
    if (game.isSwapMode) {
      _handleSwap();
      return true;
    }

    // 💣 2️⃣ PATLATMA MODLARI
    if (isEnemy) {
      if (game.isSingleExplosion) {
        explode();
        game.isSingleExplosion = false;
        return true;
      }

      if (game.isRowColumnExplosion) {
        breakAllRowAndColumn();
        game.isRowColumnExplosion = false;
        return true;
      }
    }

    return false;
  }
}
