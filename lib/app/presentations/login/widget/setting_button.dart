import 'package:connect_four/app/common/color/app_color.dart';
import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const SettingButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Icon(color: AppColor.white, Icons.settings, size: 30),
    );
  }
}
