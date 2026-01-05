import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [SvgPicture.asset(AssetImages.iconText.path)]),
    );
  }
}
