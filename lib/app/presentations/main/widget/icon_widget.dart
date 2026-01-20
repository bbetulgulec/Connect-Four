import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final String iconPath;
  final double size;
  final BoxFit fit;
  final VoidCallback? onTap;
  const IconWidget({
    super.key,
    required this.iconPath,
    this.size = 80,
    this.fit = BoxFit.contain,
     this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(iconPath, width: size, height: size, fit: fit),
      ),
    );
  }
}
