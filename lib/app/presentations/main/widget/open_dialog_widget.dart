import 'dart:ui';

import 'package:connect_four/app/common/color/app_color.dart';
import 'package:connect_four/app/presentations/main/view/main_screen.dart';
import 'package:connect_four/app/presentations/main/widget/build_arrow.dart';
import 'package:connect_four/app/presentations/main/widget/row_column_explosion_demo_game.dart';
import 'package:connect_four/app/presentations/main/widget/single_explosion_demo_game.dart';
import 'package:connect_four/app/presentations/main/widget/swap_demo_game.dart';
import 'package:connect_four/app/presentations/main/widget/undo_demo_game.dart';
import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:connect_four/core/extensions/build_context_extensions.dart';
import 'package:connect_four/core/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class OpenDialogWidget extends StatefulWidget {
  final ActionType initialAction;

  const OpenDialogWidget({super.key, required this.initialAction});

  @override
  State<OpenDialogWidget> createState() => _OpenDialogWidgetState();
}

class _OpenDialogWidgetState extends State<OpenDialogWidget> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = ActionType.values.indexOf(widget.initialAction);
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SizedBox(
            height: context.height280 * 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      /// SOL OK
                      BuildArrow(
                        icon: Icons.arrow_back_ios_rounded,
                        enabled: _currentPage > 0,
                        onTap: () {
                          if (_currentPage > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),

                      /// PAGEVIEW
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          itemCount: ActionType.values.length,
                          itemBuilder: (context, index) {
                            final action = ActionType.values[index];

                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  /// ICON
                                  Container(
                                    width: context.width80,
                                    height: context.height80,
                                    padding: EdgeInsets.only(
                                      top: context.height10,
                                    ),
                                    child: Image.asset(_iconPath(action)),
                                  ),
                                  SizedBox(height: context.height10),

                                  /// DEMO
                                  SizedBox(
                                    height: context.height200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: GameWidget(
                                        game: _buildGame(action),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: context.height20),

                                  /// TITLE
                                  Text(
                                    _getTitle(action),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.redAccent,
                                    ),
                                  ),

                                  SizedBox(height: context.height20),

                                  /// DESCRIPTION
                                  Text(
                                    _getDescription(action),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),

                                  SizedBox(height: context.height20),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      /// SAĞ OK
                      BuildArrow(
                        icon: Icons.arrow_forward_ios_rounded,
                        enabled: _currentPage < ActionType.values.length - 1,
                        onTap: () {
                          if (_currentPage < ActionType.values.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: context.height20),

                /// =======================
                /// DOT INDICATOR
                /// =======================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    ActionType.values.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.redAccent
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// =======================
                /// BUTTON
                /// =======================
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: context.height12,
                    horizontal: context.width12,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 76, 175, 173),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLocalization.translate("ıGetIt"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15,
                      ),
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

  String _iconPath(ActionType action) {
    switch (action) {
      case ActionType.singleExplosion:
        return AssetImages.block_1explosion.path(AssetType.png);
      case ActionType.rowColumnExplosion:
        return AssetImages.column_1row_1deletion.path(AssetType.png);
      case ActionType.swap:
        return AssetImages.swap.path(AssetType.png);
      case ActionType.undo:
        return AssetImages.undo_1move.path(AssetType.png);
    }
  }

  String _getTitle(ActionType action) {
    switch (action) {
      case ActionType.swap:
        return AppLocalization.translate("swapDemoSwap");

      case ActionType.singleExplosion:
        return AppLocalization.translate("singleExplosion");
      case ActionType.rowColumnExplosion:
        return AppLocalization.translate("rowColumnExplosion");
      case ActionType.undo:
        return AppLocalization.translate("undo");
    }
  }

  String _getDescription(ActionType action) {
    switch (action) {
      case ActionType.swap:
        return AppLocalization.translate("swapDemoSwapDesciription");
      case ActionType.singleExplosion:
        return AppLocalization.translate("singleExplosionDesciription");
      case ActionType.rowColumnExplosion:
        return AppLocalization.translate("rowColumnExplosionDesciription");
      case ActionType.undo:
        return AppLocalization.translate("undoDesciription");
    }
  }
}
