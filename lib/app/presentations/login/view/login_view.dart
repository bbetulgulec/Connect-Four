import 'package:connect_four/app/presentations/login/widget/dialog_widget.dart';
import 'package:connect_four/app/presentations/login/widget/material_button_widget.dart';
import 'package:connect_four/app/presentations/login/widget/setting_button.dart';
import 'package:connect_four/app/presentations/login/widget/title_widget.dart';
import 'package:connect_four/app/presentations/main/view/main_screen.dart';
import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:connect_four/core/helper/nav_helper/navigation_helper.dart';

import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(color: null),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AssetImages.background.path(AssetType.png),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  TitleWidget(),
                  const SizedBox(height: 16),

                  MaterialButtonWidget(
                    text: "Devam Et",
                    color: Colors.redAccent,
                    onPressed: () {
                      // işlem
                    },
                  ),

                  const SizedBox(height: 16),

                  MaterialButtonWidget(
                    text: "Yeni Oyun",
                    color: Colors.yellow,
                    onPressed: () {
                      Navigation.pushAndRemoveAll(page: MainScreen());
                    },
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Align(
                alignment: AlignmentGeometry.topRight,

                child: SettingButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DialogWidget();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
