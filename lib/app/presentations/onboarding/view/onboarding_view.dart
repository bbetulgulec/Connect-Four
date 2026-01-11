import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(AssetImages.background.path)),
        ],
      ),
    );
  }
}
