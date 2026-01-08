import 'package:connect_four/app/presentations/login/widget/login_material_button.dart';
import 'package:connect_four/app/presentations/login/widget/setting_button.dart';
import 'package:connect_four/app/presentations/main/view/main_screen.dart';
import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:connect_four/core/extensions/build_context_extensions.dart';
import 'package:connect_four/core/helper/nav_helper/navigation_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(color: null),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.40,
                child: SvgPicture.asset(
                  AssetImages.background.path,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
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

                  LoginMaterialButton(
                    text: "Yeni oyun",
                    onTap: () {
                      Navigation.push(page: MainScreen());
                    },
                  ),

                  const SizedBox(height: 16),

                  LoginMaterialButton(text: "Devam Et"),

                  const SizedBox(height: 60),
                ],
              ),
            ),

            Positioned(right: 16, bottom: 16, child: SettingButton()),
          ],
        ),
      ),
    );
  }
}
