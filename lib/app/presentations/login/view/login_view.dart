import 'package:connect_four/app/common/color/app_color.dart';
import 'package:connect_four/app/presentations/login/provider/login_provider.dart';
import 'package:connect_four/app/presentations/login/widget/dialog_widget.dart';
import 'package:connect_four/app/presentations/login/widget/material_button_widget.dart';
import 'package:connect_four/app/presentations/login/widget/setting_button.dart';
import 'package:connect_four/app/presentations/login/widget/title_widget.dart';
import 'package:connect_four/core/extensions/asset_extension.dart';
import 'package:connect_four/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<LoginProvider>();
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
                  SizedBox(height: context.height32),

                  MaterialButtonWidget(
                    text: "Devam Et",
                    color: AppColor.redButton,
                    onPressed: () {
                      provider.longAlarmBuzz();
                      provider.contuniePage(context);
                    },
                  ),

                  SizedBox(height: context.height16),

                  MaterialButtonWidget(
                    text: "Yeni Oyun",
                    color: AppColor.yellow,
                    onPressed: () async {
                      provider.longAlarmBuzz();

                      provider.newGame(context);
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: context.height32),
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
