import 'dart:ui';
import 'package:connect_four/app/presentations/login/provider/login_provider.dart';
import 'package:connect_four/app/presentations/login/widget/build_setting_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<LoginProvider>();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(55),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withAlpha(60)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),

                // BİLDİRİM SWITCH
                BuildSettingRow(
                  title: "Bildirimler :",
                  value: provider.isNotificationEnabled,
                  onChanged: (bool value) async {
                    await provider.setNotificationEnabled(value);
                  },
                ),

                // SES SWITCH
                BuildSettingRow(
                  title: "Sesler :",
                  value: provider.isMuted,
                  onChanged: (bool value) async {
                    provider.voiceSwitch(value);
                  },
                ),

                // TİTREŞİM SWITCH
                BuildSettingRow(
                  title: "Titreşimler :",
                  value: provider.isClosedVibration,
                  onChanged: (bool value) async {
                    provider.vibrationSwitch(value);
                  },
                ),
                const SizedBox(height: 16),
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
        const Expanded(
          child: Center(
            child: Text(
              "Ayarlar",
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
