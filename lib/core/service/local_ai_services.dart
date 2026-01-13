import 'dart:math';

class LocalAiService {
  static const int rows = 8;
  static const int cols = 6;
  static const int aiPlayer = 2;
  static const int humanPlayer = 1;

  static int getBestMove(List<List<int>> board) {
    //  AI kazanabiliyor mu?
    for (int col = 0; col < cols; col++) {
      if (_canDrop(board, col)) {
        final copy = _copyBoard(board);
        _drop(copy, col, aiPlayer);
        if (_checkWin(copy, aiPlayer)) {
          return col;
        }
      }
    }

    //  Oyuncuyu blokla
    for (int col = 0; col < cols; col++) {
      if (_canDrop(board, col)) {
        final copy = _copyBoard(board);
        _drop(copy, col, humanPlayer);
        if (_checkWin(copy, humanPlayer)) {
          return col;
        }
      }
    }

    // 3️⃣ Orta kolonları tercih et
    final center = cols ~/ 2;
    if (_canDrop(board, center)) return center;

    // 4️⃣ Rastgele
    final validMoves = <int>[];
    for (int col = 0; col < cols; col++) {
      if (_canDrop(board, col)) validMoves.add(col);
    }

    return validMoves[Random().nextInt(validMoves.length)];
  }

  // ---------- HELPERS ----------

  static bool _canDrop(List<List<int>> board, int col) {
    return board[0][col] == 0;
  }

  static void _drop(List<List<int>> board, int col, int player) {
    for (int row = rows - 1; row >= 0; row--) {
      if (board[row][col] == 0) {
        board[row][col] = player;
        break;
      }
    }
  }

  static List<List<int>> _copyBoard(List<List<int>> board) {
    return board.map((r) => List<int>.from(r)).toList();
  }

  static bool _checkWin(List<List<int>> board, int player) {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (_checkDir(board, r, c, 1, 0, player) || // →
            _checkDir(board, r, c, 0, 1, player) || // ↓
            _checkDir(board, r, c, 1, 1, player) || // ↘
            _checkDir(board, r, c, 1, -1, player)) {
          return true;
        }
      }
    }
    return false;
  }

  static bool _checkDir(
    List<List<int>> board,
    int r,
    int c,
    int dr,
    int dc,
    int player,
  ) {
    for (int i = 0; i < 4; i++) {
      final nr = r + dr * i;
      final nc = c + dc * i;
      if (nr < 0 ||
          nr >= rows ||
          nc < 0 ||
          nc >= cols ||
          board[nr][nc] != player) {
        return false;
      }
    }
    return true;
  }
}
