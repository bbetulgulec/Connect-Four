import 'package:connect_four/app/presentations/login/widget/switch_widget.dart';
import 'package:flutter/material.dart';

class BuildSettingRow extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  const BuildSettingRow({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          const Spacer(),
          SwitchWidget(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
