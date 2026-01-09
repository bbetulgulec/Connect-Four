import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  const SwitchWidget({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: onChanged,
      activeThumbColor: Colors.redAccent,
      activeTrackColor: Colors.redAccent.shade100,
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey.shade100,
      value: value,
    );
  }
}
