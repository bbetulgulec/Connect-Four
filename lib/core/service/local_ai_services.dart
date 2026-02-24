import 'dart:math';

class LocalAiService {
  static const int rows = 8;
  static const int cols = 7;
  static const int aiPlayer = 2;
  static const int humanPlayer = 1;
  static const int maxDepth = 6; // 5-7 ideal

  static int getBestMove(List<List<int>> board) {
    int bestScore = -999999;
    int bestCol = 0;

    for (int col in _validMoves(board)) {
      final copy = _copyBoard(board);
      _drop(copy, col, aiPlayer);

      int score = _minimax(copy, maxDepth - 1, -1000000, 1000000, false);

      if (score > bestScore) {
        bestScore = score;
        bestCol = col;
      }
    }

    return bestCol;
  }

  // ---------------- MINIMAX ----------------

  static int _minimax(
    List<List<int>> board,
    int depth,
    int alpha,
    int beta,
    bool maximizing,
  ) {
    if (_checkWin(board, aiPlayer)) return 100000;
    if (_checkWin(board, humanPlayer)) return -100000;
    if (depth == 0 || _validMoves(board).isEmpty) {
      return _evaluateBoard(board);
    }

    if (maximizing) {
      int value = -999999;
      for (int col in _validMoves(board)) {
        final copy = _copyBoard(board);
        _drop(copy, col, aiPlayer);
        value = max(value, _minimax(copy, depth - 1, alpha, beta, false));
        alpha = max(alpha, value);
        if (alpha >= beta) break;
      }
      return value;
    } else {
      int value = 999999;
      for (int col in _validMoves(board)) {
        final copy = _copyBoard(board);
        _drop(copy, col, humanPlayer);
        value = min(value, _minimax(copy, depth - 1, alpha, beta, true));
        beta = min(beta, value);
        if (alpha >= beta) break;
      }
      return value;
    }
  }

  // ---------------- HEURISTIC ----------------

  static int _evaluateBoard(List<List<int>> board) {
    int score = 0;

    // Merkez kontrolü
    int centerCol = cols ~/ 2;
    int centerCount = 0;
    for (int r = 0; r < rows; r++) {
      if (board[r][centerCol] == aiPlayer) centerCount++;
    }
    score += centerCount * 6;

    // Tüm window'ları kontrol et
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        score += _evaluateWindow(board, r, c, 1, 0);
        score += _evaluateWindow(board, r, c, 0, 1);
        score += _evaluateWindow(board, r, c, 1, 1);
        score += _evaluateWindow(board, r, c, 1, -1);
      }
    }

    return score;
  }

  static int _evaluateWindow(
    List<List<int>> board,
    int r,
    int c,
    int dr,
    int dc,
  ) {
    int aiCount = 0;
    int humanCount = 0;
    int empty = 0;

    for (int i = 0; i < 4; i++) {
      int nr = r + dr * i;
      int nc = c + dc * i;

      if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) {
        return 0;
      }

      if (board[nr][nc] == aiPlayer)
        aiCount++;
      else if (board[nr][nc] == humanPlayer)
        humanCount++;
      else
        empty++;
    }

    if (aiCount == 4) return 100000;
    if (aiCount == 3 && empty == 1) return 100;
    if (aiCount == 2 && empty == 2) return 10;

    if (humanCount == 3 && empty == 1) return -120;
    if (humanCount == 2 && empty == 2) return -10;

    return 0;
  }

  // ---------------- HELPERS ----------------

  static List<int> _validMoves(List<List<int>> board) {
    List<int> moves = [];
    for (int c = 0; c < cols; c++) {
      if (board[0][c] == 0) moves.add(c);
    }
    return moves;
  }

  static void _drop(List<List<int>> board, int col, int player) {
    for (int r = rows - 1; r >= 0; r--) {
      if (board[r][col] == 0) {
        board[r][col] = player;
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
        if (_checkDir(board, r, c, 1, 0, player) ||
            _checkDir(board, r, c, 0, 1, player) ||
            _checkDir(board, r, c, 1, 1, player) ||
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
      int nr = r + dr * i;
      int nc = c + dc * i;

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
