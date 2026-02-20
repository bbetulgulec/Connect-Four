import 'package:connect_four/app/common/color/app_color.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Connect Four\nChallenge',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontFamily: "Nunito",
        color: AppColor.white,
        fontSize: 50,
        shadows: [
          Shadow(blurRadius: 20, color: Colors.pinkAccent),
          Shadow(blurRadius: 40, color: Colors.redAccent),
        ],
      ),
    );
  }
}
