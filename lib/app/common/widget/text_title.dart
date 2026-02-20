import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String title;
  const TextTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontFamily: "Nunito",
        color: Colors.white,
        fontSize: 32,
        shadows: [
          Shadow(blurRadius: 20, color: Colors.deepOrangeAccent),
          Shadow(blurRadius: 40, color: Colors.redAccent),
        ],
      ),
    );
  }
}
