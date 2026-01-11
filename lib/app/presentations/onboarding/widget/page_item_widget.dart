import 'package:flutter/material.dart';

class PageItemWidget extends StatelessWidget {
  final String imagePath;
  const PageItemWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [Image.asset(imagePath)]));
  }
}
