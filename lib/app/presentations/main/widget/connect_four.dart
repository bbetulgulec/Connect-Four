import 'package:connect_four/app/data/hive/game_storage.dart';
import 'package:connect_four/app/presentations/main/component/board.dart';
import 'package:connect_four/app/presentations/main/component/piece.dart';
import 'package:connect_four/core/service/local_ai_services.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ConnectFour extends FlameGame with TapCallbacks {
  static const int rows = 8;
  static const int cols = 7;
  bool isPlayerTurn = true;
  bool isSwapMode = false;
  Piece? firstSelectedPiece;

  late double cellSize;
  late Vector2 boardPosition;

  int currentPlayer = 1;
  bool isGameOver = false;
  bool isExplosionMode = false;

  bool isSingleExplosion = false;
  bool isRowColumnExplosion = false;

  // 0 = boş, 1 = kırmızı, 2 = yeşil
  final List<List<int>> board = List.generate(
    rows,
    (_) => List.filled(cols, 0),
  );

  int player1Score = 0;
  int player2Score = 0;

  final List<Piece> pieces = []; // ← Yeni liste ekle
  final GameStorage _storage = GameStorage();

  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);

  void resetGame() {
    // Tahtayı sıfırla
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        board[r][c] = 0;
      }
    }

    // Tüm Piece'leri kaldır
    for (final piece in pieces) {
      piece.removeFromParent(); // veya remove(piece)
    }
    pieces.clear(); // listeyi boşalt

    isGameOver = false;
    currentPlayer = 1;

    player1Score = 0;
    isPlayerTurn = true;
    scoreNotifier.value = 0;
  }

  void applyGravity() {
    bool moved;

    do {
      moved = false;

      // alttan yukarı sırala
      final sortedPieces = List<Piece>.from(pieces)
        ..sort((a, b) => b.row.compareTo(a.row));

      for (final piece in sortedPieces) {
        final belowRow = piece.row + 1;

        if (belowRow < rows && board[belowRow][piece.col] == 0) {
          // board güncelle
          board[piece.row][piece.col] = 0;
          board[belowRow][piece.col] = piece.player;

          piece.row = belowRow;

          final targetY = boardPosition.y + belowRow * cellSize + cellSize / 2;

          piece.add(
            MoveEffect.to(
              Vector2(piece.position.x, targetY),
              EffectController(duration: 0.22, curve: Curves.easeIn),
            ),
          );

          moved = true; // ⬅️ ÇOK KRİTİK
        }
      }
    } while (moved); // 🔥 boşluk kalmayana kadar
  }

  void swapPieces(Piece a, Piece b) {
    // 1️⃣ Pozisyonları sakla
    final Vector2 posA = a.position.clone();
    final Vector2 posB = b.position.clone();

    // 2️⃣ Row / Col sakla
    final int rowA = a.row;
    final int colA = a.col;
    final int rowB = b.row;
    final int colB = b.col;

    // 3️⃣ Board güncelle
    board[rowA][colA] = b.player;
    board[rowB][colB] = a.player;

    // 4️⃣ Row / Col swap
    a.row = rowB;
    a.col = colB;
    b.row = rowA;
    b.col = colA;

    // 5️⃣ Animasyon (2 saniye)
    a.add(MoveEffect.to(posB, CurvedEffectController(1, Curves.easeInOut)));

    b.add(MoveEffect.to(posA, CurvedEffectController(1, Curves.easeInOut)));
  }

  void _dropPiece(int col, int player) {
    for (int row = rows - 1; row >= 0; row--) {
      if (board[row][col] == 0) {
        board[row][col] = player;
        _addPiece(row, col, player);

        // 🔥 TAŞ ATTIKÇA PUAN
        if (player == 1) {
          player1Score++;
          scoreNotifier.value = player1Score; // 🔥 üst UI güncellenir
        }

        if (_checkWin(player)) {
          isGameOver = true;
          final isWin = player == 1;

          _storage.onGameFinished(
            isWin: isWin,
            score: player1Score, // 🔥 ARTAN DEĞER
          );

          overlays.add(isWin ? 'WinOverlay' : 'LoseOverlay');
        }

        break;
      }
    }
  }

  void _addPiece(int row, int col, int player) {
    final targetPosition = Vector2(
      boardPosition.x + col * cellSize + cellSize / 2,
      boardPosition.y + row * cellSize + cellSize / 2,
    );

    final startPosition = Vector2(
      targetPosition.x,
      boardPosition.y - cellSize * 1.5,
    );

    final piece = Piece(
      player: player,
      startPosition: startPosition,
      targetPosition: targetPosition,
      cellSize: cellSize,
      col: col,
      row: row,
      isEnemy: player == 2,
      game: this,
    );

    add(piece);
    pieces.add(piece); // ← buraya ekle
  }

  Piece? getEnemyPieceAt({required int col, required int row}) {
    for (final piece in pieces) {
      if (piece.col == col && piece.row == row && piece.isEnemy) {
        return piece;
      }
    }
    return null;
  }

  Future<void> _makeAiMove() async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (isGameOver) return;

    final aiColumn = LocalAiService.getBestMove(board);
    _dropPiece(aiColumn, 2);

    if (!isGameOver) {
      isPlayerTurn = true; // 🔓 tekrar sen
    }
  }

  @override
  Color backgroundColor() => Colors.transparent;

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

    if (isGameOver || !isPlayerTurn) return;

    _dropPiece(col, 1); // SEN
    isPlayerTurn = false;

    await Future.delayed(const Duration(milliseconds: 500));

    await _makeAiMove(); // AI
  }

  bool _checkWin(int player) {
    // Dikey
    for (int col = 0; col < cols; col++) {
      for (int row = 0; row <= rows - 4; row++) {
        if (board[row][col] == player &&
            board[row + 1][col] == player &&
            board[row + 2][col] == player &&
            board[row + 3][col] == player) {
          return true;
        }
      }
    }

    // Yatay
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col <= cols - 4; col++) {
        if (board[row][col] == player &&
            board[row][col + 1] == player &&
            board[row][col + 2] == player &&
            board[row][col + 3] == player) {
          return true;
        }
      }
    }

    // Çapraz (sol üst → sağ alt)
    for (int row = 0; row <= rows - 4; row++) {
      for (int col = 0; col <= cols - 4; col++) {
        if (board[row][col] == player &&
            board[row + 1][col + 1] == player &&
            board[row + 2][col + 2] == player &&
            board[row + 3][col + 3] == player) {
          return true;
        }
      }
    }

    // Çapraz (sağ üst → sol alt)
    for (int row = 0; row <= rows - 4; row++) {
      for (int col = 3; col < cols; col++) {
        if (board[row][col] == player &&
            board[row + 1][col - 1] == player &&
            board[row + 2][col - 2] == player &&
            board[row + 3][col - 3] == player) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  Future<void> onLoad() async {
    cellSize = size.x / (cols + 1);
    final boardWidth = cellSize * cols;
    final boardHeight = cellSize * rows;

    boardPosition = Vector2(
      (size.x - boardWidth) / 2,
      (size.y - boardHeight) / 2,
    );
    add(
      Board(
        rows: rows,
        cols: cols,
        cellSize: cellSize,
        position: boardPosition,
      ),
    );
  }
}
