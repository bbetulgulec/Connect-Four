import 'package:connect_four/app/home/widget/home_material_button.dart';
import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:connect_four/core/extensions/build_context_extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AssetImages.iconText.path,
              width: context.width120,
              height: context.height120,
            ),

            const SizedBox(height: 16),

            HomeMaterialButton(),
          ],
        ),
      ),
    );
  }
}
