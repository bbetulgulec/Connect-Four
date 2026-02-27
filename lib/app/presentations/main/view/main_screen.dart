import 'package:connect_four/app/common/color/app_color.dart';
import 'package:connect_four/app/common/widget/text_title.dart';
import 'package:connect_four/app/presentations/main/widget/banner_add_widget.dart';
import 'package:connect_four/app/presentations/main/widget/tabbar_widget.dart';
import 'package:connect_four/core/extensions/build_context_extensions.dart';
import 'package:connect_four/app/presentations/main/provider/main_provider.dart';
import 'package:connect_four/app/presentations/main/widget/connect_four.dart';
import 'package:connect_four/app/presentations/main/widget/icon_widget.dart';
import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:connect_four/core/localization/app_localization.dart';
import 'package:connect_four/core/service/hive_service.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:connect_four/app/presentations/main/widget/dialog_widget.dart';
import 'package:provider/provider.dart';

enum ActionType { singleExplosion, rowColumnExplosion, swap, undo }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      HiveService.deleteData('current_game');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MainProvider>();
    final game = provider.game;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.checkAndShowTutorial(context);
    });
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.image.path(AssetType.png)),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width10),
                child: TabbarWidget(),
              ),
            ),

            /// SCORE BAR
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextTitle.futu(
                    title: AppLocalization.translate("score"),
                    notifier: game.scoreNotifier,
                    color: AppColor.yellow,
                  ),
                  TextTitle.futu(
                    title: AppLocalization.translate("level"),
                    notifier: game.levelNotifier,
                    color: AppColor.turquoise,
                  ),
                  TextTitle.futu(
                    title: AppLocalization.translate("best"),
                    notifier: game.bestScoreNotifier,
                  ),
                ],
              ),
            ),

            /// GAME
            AspectRatio(
              aspectRatio: 1,
              child: GameWidget<ConnectFour>(
                game: game,
                overlayBuilderMap: {
                  'WinOverlay': (_, game) => DialogWidget(
                    result: GameResult.win,
                    onPlayAgain: () {
                      final provider = context.read<MainProvider>();

                      provider.game.resetGame();
                      game.overlays.remove('WinOverlay');
                    },
                  ),
                  'LoseOverlay': (_, game) => DialogWidget(
                    result: GameResult.lose,
                    onPlayAgain: () {
                      final provider = context.read<MainProvider>();

                      provider.game.resetGame();
                      game.overlays.remove('LoseOverlay');
                    },
                  ),
                  'NoSpace': (_, game) => DialogWidget(
                    result: GameResult.noSpace,
                    onPlayAgain: () {
                      final provider = context.read<MainProvider>();

                      provider.game.resetGame();
                      game.overlays.remove('NoSpace'); // BURAYA EKLE (Eksikti)
                    },
                  ),
                },
              ),
            ),

            /// ACTION BAR
            Consumer<MainProvider>(
              builder: (context, mainProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ActionType.values.map((action) {
                    return Opacity(
                      opacity: provider.opacity(action),
                      child: IconWidget(
                        iconPath: _iconPath(action),
                        badgeCount: provider.getSkillCount(action),
                        onTap: () {
                          provider.selectAction(action, context);
                          debugPrint('basıldı');
                        },
                        onLongComplete: () => provider.selectActionLong(action),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            BannerAdWidget(),
          ],
        ),
      ),
    );
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
}
