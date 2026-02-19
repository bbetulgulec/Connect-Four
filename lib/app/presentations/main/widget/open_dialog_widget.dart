import 'dart:ui';

import 'package:connect_four/app/presentations/main/view/main_screen.dart';
import 'package:connect_four/app/presentations/main/widget/row_column_explosion_demo_game.dart';
import 'package:connect_four/app/presentations/main/widget/single_explosion_demo_game.dart';
import 'package:connect_four/app/presentations/main/widget/swap_demo_game.dart';
import 'package:connect_four/app/presentations/main/widget/undo_demo_game.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class OpenDialogWidget extends StatefulWidget {
  final ActionType initialAction; // İlk hangi yetenekle açılsın?

  const OpenDialogWidget({super.key, required this.initialAction});

  @override
  State<OpenDialogWidget> createState() => _OpenDialogWidgetState();
}

class _OpenDialogWidgetState extends State<OpenDialogWidget> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // İlk açılacak sayfayı bul
    _currentPage = ActionType.values.indexOf(widget.initialAction);
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(55),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withAlpha(60)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 280, 
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemCount: ActionType.values.length,
                    itemBuilder: (context, index) {
                      final action = ActionType.values[index];
                      return Column(
                        children: [
                          // Oyun Demosu
                          SizedBox(
                            width: 200,
                            height: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: GameWidget(game: _buildGame(action)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Açıklama Metni
                          Text(
                            _getTitle(action),
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getDescription(action),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                /// Sayfa Göstergeleri (Noktalar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    ActionType.values.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 20 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.redAccent
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 175, 173),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "ANLADIM",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FlameGame _buildGame(ActionType action) {
    switch (action) {
      case ActionType.swap:
        return SwapDemoGame();
      case ActionType.singleExplosion:
        return SingleExplosionDemoGame();
      case ActionType.rowColumnExplosion:
        return RowColumnExplosionDemoGame();
      case ActionType.undo:
        return UndoDemoGame();
    }
  }

  String _getTitle(ActionType action) {
    switch (action) {
      case ActionType.swap:
        return "Taş Değiştir";
      case ActionType.singleExplosion:
        return "Tekli Patlama";
      case ActionType.rowColumnExplosion:
        return "Sıra Temizle";
      case ActionType.undo:
        return "Geri Al";
    }
  }

  String _getDescription(ActionType action) {
    switch (action) {
      case ActionType.swap:
        return "İstediğin iki taşın yerini\nanında değiştirir.";
      case ActionType.singleExplosion:
        return "Seçtiğin herhangi bir taşı\ntahtadan siler.";
      case ActionType.rowColumnExplosion:
        return "Dikey ve yatay tüm hattı\ntek seferde patlatır.";
      case ActionType.undo:
        return "Yaptığın son hamleyi\nhiç olmamış gibi geri sarar.";
    }
  }
}
