import 'package:flutter/material.dart';

class ScorText extends StatelessWidget {
  final ValueNotifier<int> notifier;
  final String title;

  const ScorText({super.key, required this.notifier, required this.title});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: notifier,
      builder: (_, value, _) {
        return Text(
          '$title: $value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
