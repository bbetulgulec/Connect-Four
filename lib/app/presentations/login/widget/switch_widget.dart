import 'package:connect_four/app/common/color/app_color.dart';
import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  const SwitchWidget({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: onChanged,
      activeThumbColor: AppColor.redAccent,
      activeTrackColor: Colors.redAccent.shade100,
      inactiveThumbColor: AppColor.grey,
      inactiveTrackColor: Colors.grey.shade100,
      value: value,
    );
  }
}
