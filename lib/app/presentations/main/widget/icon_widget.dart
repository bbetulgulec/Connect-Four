import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final String iconPath;
  final double size;
  final BoxFit fit;

  const IconWidget({
    super.key,
    required this.iconPath,
    this.size = 80,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(iconPath, width: size, height: size, fit: fit),
    );
  }
}
