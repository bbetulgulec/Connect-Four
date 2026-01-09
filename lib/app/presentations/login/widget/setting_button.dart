import 'package:connect_four/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  const SettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      child: Icon(color: Colors.white, Icons.settings, size: 30),
    );
  }
}
