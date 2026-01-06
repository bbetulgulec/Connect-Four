import 'package:connect_four/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  const SettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      child: Container(
        height: context.height60,
        width: context.width60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 56, 28, 105),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            width: 1.0,
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),

        child: Icon(color: Colors.white, Icons.settings),
      ),
    );
  }
}
