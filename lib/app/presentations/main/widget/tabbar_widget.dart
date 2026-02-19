import 'package:connect_four/app/presentations/main/provider/main_provider.dart'; // 1. MainProvider'ı import et
import 'package:connect_four/app/presentations/main/view/main_screen.dart';
import 'package:connect_four/app/presentations/main/widget/open_dialog_widget.dart';
import 'package:connect_four/core/service/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabbarWidget extends StatelessWidget {
  const TabbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. LoginProvider yerine MainProvider'ı oku
    final provider = context.read<MainProvider>();

    return Row(
      children: [
        GestureDetector(
          onTap: () {
             HiveService.deleteData('current_game');
            // 3. MainProvider içindeki game üzerinden resetle
            provider.game.resetGame();
          },
          child: const Icon(Icons.replay, color: Colors.white, size: 30.0),
        ),
        const SizedBox(width: 8), // İkonlar arası biraz boşluk
        GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (context) => const OpenDialogWidget(
              initialAction: ActionType.singleExplosion,
            ),
          ),
          child: const Icon(Icons.info, color: Colors.white, size: 30.0),
        ),
      ],
    );
  }
}
