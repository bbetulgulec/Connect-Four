import 'package:connect_four/app/data/models/active_game.dart';
import 'package:connect_four/core/service/hive_service.dart';
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
  VoidCallback? onTurnEnded;

  late double cellSize;
  late Vector2 boardPosition;

  int currentPlayer = 1;
  bool isGameOver = false;
  bool isExplosionMode = false;

  bool isSingleExplosion = false;
  bool isRowColumnExplosion = false;
  VoidCallback? onSkillFinished;
  int? lastPlayerRow;
  int? lastPlayerCol;
  Piece? lastPlayerPiece;

  // 0 = boş, 1 = kırmızı, 2 = yeşil
  final List<List<int>> board = List.generate(
    rows,
    (_) => List.filled(cols, 0),
  );

  int player1Score = 0;
  int player2Score = 0;

  final List<Piece> pieces = [];

  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);

  final ActiveGame? initialGame;

  ConnectFour({this.initialGame});

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scoreNotifier.value = 0;
    });
  }

  void applyGravity() {
    for (int col = 0; col < cols; col++) {
      int writeRow = rows - 1;

      for (int row = rows - 1; row >= 0; row--) {
        if (board[row][col] != 0) {
          if (row != writeRow) {
            // board güncelle
            board[writeRow][col] = board[row][col];
            board[row][col] = 0;

            // piece bul
            final piece = pieces.firstWhere(
              (p) => p.row == row && p.col == col,
            );

            piece.row = writeRow;

            final targetY =
                boardPosition.y + writeRow * cellSize + cellSize / 2;

            piece.add(
              MoveEffect.to(
                Vector2(piece.position.x, targetY),
                EffectController(duration: 0.25, curve: Curves.easeIn),
              ),
            );
          }

          writeRow--;
        }
      }
    }
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scoreNotifier.value = player1Score;
          });
          lastPlayerRow = row;
          lastPlayerCol = col;
          lastPlayerPiece = pieces.last;
        }
        if (_checkWin(player)) {
          isGameOver = true;
          final isWin = player == 1;

          // 🔥 Eski storage yerine yeni servisimizi kullanıyoruz
          if (isWin) {
            final currentProgress = HiveService.getProgress();
            final currentScore = scoreNotifier.value;

            // En yüksek skor kontrolü
            if (currentScore > (currentProgress['highScore'] ?? 0)) {
              currentProgress['highScore'] = currentScore;
            }

            // Coin ekleme
            currentProgress['coins'] = (currentProgress['coins'] ?? 0) + 10;

            // Kaydet
            HiveService.saveProgress(currentProgress);
          }

          // Oyun bittiği için aktif kaydı siliyoruz
          HiveService.deleteActiveGame();

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
      isPlayerTurn = true;
      isSingleExplosion = false;
      isRowColumnExplosion = false;
      isSwapMode = false;
      firstSelectedPiece = null;
    }

    onTurnEnded?.call();
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
    saveGame();

    await Future.delayed(const Duration(milliseconds: 500));

    await _makeAiMove(); // AI
    saveGame();
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

  void saveGame() {
    // 1. Mevcut oyun durumundan bir ActiveGame nesnesi yarat
    final activeGameInstance = ActiveGame(
      board: board,
      currentPlayer: currentPlayer,
      isPlayerTurn: isPlayerTurn,
      isGameOver: isGameOver,
      score: scoreNotifier.value,
    );

    // 2. Servis üzerinden JSON olarak kaydet
    // Not: ActiveGame modelinde .toJson() metodun olmalı
    HiveService.saveActiveGame(activeGameInstance.toJson());
  }

  void loadFromHive(ActiveGame data) {
    pieces.clear(); // üst üste binmeyi önler

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        board[r][c] = data.board[r][c];

        if (board[r][c] != 0) {
          _addPiece(r, c, board[r][c]);
        }
      }
    }

    currentPlayer = data.currentPlayer;
    isPlayerTurn = data.isPlayerTurn;
    isGameOver = data.isGameOver;

    // 🔥 Burayı post-frame callback ile yap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scoreNotifier.value = data.score;
    });
  }

  Future<void> finishPlayerTurnAfterSkill() async {
    if (isGameOver) return;

    isPlayerTurn = false;
    saveGame();

    await Future.delayed(const Duration(milliseconds: 400));

    await _makeAiMove(); // AI oynasın
    saveGame();
    // BUNU EKLE
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
    if (initialGame != null) {
      loadFromHive(initialGame!);
    }
  }

  Future<void> undoLastMove() async {
    if (lastPlayerPiece == null ||
        lastPlayerRow == null ||
        lastPlayerCol == null)
      return;

    final piece = lastPlayerPiece!;

    // Board temizle
    board[lastPlayerRow!][lastPlayerCol!] = 0;

    // Skor azalt
    if (player1Score > 0) {
      player1Score--;
      scoreNotifier.value = player1Score;
    }

    // Yukarı animasyon
    piece.add(
      MoveEffect.to(
        Vector2(piece.position.x, boardPosition.y - cellSize * 2),
        EffectController(duration: 0.6, curve: Curves.easeInBack),
        onComplete: () {
          piece.removeFromParent();
          pieces.remove(piece);
        },
      ),
    );

    // Reset last move
    lastPlayerPiece = null;
    lastPlayerRow = null;
    lastPlayerCol = null;

    await Future.delayed(const Duration(milliseconds: 600));

    await finishPlayerTurnAfterSkill();
  }
}
