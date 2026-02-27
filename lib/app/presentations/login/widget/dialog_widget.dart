import 'dart:ui';
import 'package:connect_four/app/common/color/app_color.dart';
import 'package:connect_four/app/presentations/login/provider/login_provider.dart';
import 'package:connect_four/app/presentations/login/widget/build_setting_row.dart';
import 'package:connect_four/core/extensions/build_context_extensions.dart';
import 'package:connect_four/core/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.width16,
              vertical: context.height20,
            ),
            decoration: BoxDecoration(
              color: AppColor.white.withAlpha(55),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.white.withAlpha(60)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                SizedBox(height: context.height20),

                // BİLDİRİM SWITCH
                BuildSettingRow(
                  title: AppLocalization.translate("notification"),
                  value: provider.isNotificationEnabled,
                  onChanged: (bool value) async {
                    await provider.setNotificationEnabled(value);
                  },
                ),

                // SES SWITCH
                BuildSettingRow(
                  title: AppLocalization.translate("voice"),
                  value: !provider.isMuted,
                  onChanged: (bool value) async {
                    provider.voiceSwitch(value);
                  },
                ),

                // TİTREŞİM SWITCH
                BuildSettingRow(
                  title: AppLocalization.translate("vibration"),
                  value: provider.isClosedVibration,
                  onChanged: (bool value) async {
                    provider.vibrationSwitch(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Yardımcı UI Metodları (Kodu temiz tutmak için)
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Text(
              AppLocalization.translate("settings"),
              style: TextStyle(
                fontFamily: "Nunito",
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.close, color: Colors.white60, size: 30),
        ),
      ],
    );
  }
}
