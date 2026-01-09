import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const SettingButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Icon(color: Colors.white, Icons.settings, size: 30),
    );
  }
}
