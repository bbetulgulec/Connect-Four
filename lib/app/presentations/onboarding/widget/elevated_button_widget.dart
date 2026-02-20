import 'package:connect_four/app/common/color/app_color.dart';
import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const ElevatedButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColor.redButton),
        ),
        child: Text(text, style: TextStyle(color: AppColor.white)),
      ),
    );
  }
}
