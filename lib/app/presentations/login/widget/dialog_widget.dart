import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:connect_four/app/data/service/hive_service.dart';
import 'package:connect_four/app/presentations/login/widget/switch_widget.dart';
import 'package:connect_four/main.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key});

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  bool isMuted = false;
  bool isClosedVibration = false;
  bool isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final voiceData = HiveService.getData('voice');
    final vibrationData = HiveService.getData('vibration');
    final notificationData = HiveService.getData('notifications');

    setState(() {
      isMuted = voiceData?['enabled'] ?? false;
      isClosedVibration = vibrationData?['enabled'] ?? false;
      isNotificationEnabled = notificationData?['enabled'] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                _buildSettingRow(
                  title: "Bildirimler :",
                  value: isNotificationEnabled,
                  onChanged: (bool value) async {
                    setState(() => isNotificationEnabled = value);
                    await HiveService.saveData('notifications', {
                      'enabled': value,
                    });

                    if (value) {
                      _showNotificationAlert(context);
                    } else {
                      flutterLocalNotificationsPlugin.cancelAll();
                    }
                  },
                ),

                // SES SWITCH
                _buildSettingRow(
                  title: "Sesler :",
                  value: isMuted,
                  onChanged: (bool value) async {
                    setState(() => isMuted = value);
                    await HiveService.saveData('voice', {'enabled': value});

                    if (value) {
                      await mainPlayer.setVolume(0.0);
                      await mainPlayer.pause();
                    } else {
                      await mainPlayer.setVolume(1.0);
                      await mainPlayer.resume();
                    }
                  },
                ),

                // TİTREŞİM SWITCH
                _buildSettingRow(
                  title: "Titreşimler :",
                  value: isClosedVibration,
                  onChanged: (bool value) async {
                    setState(() => isClosedVibration = value);
                    await HiveService.saveData('vibration', {'enabled': value});

                    if (value) {
                      Vibration.cancel();
                    } else {
                      if (await Vibration.hasVibrator()) {
                        Vibration.vibrate(duration: 50);
                      }
                    }
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

  Widget _buildSettingRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          const Spacer(),
          SwitchWidget(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  void _showNotificationAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Bildirimler"),
        content: const Text(
          "Bildirim ayarlarını değiştirmek için sistem ayarlarına gitmek ister misiniz?",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                AppSettings.openAppSettings(type: AppSettingsType.notification),
            child: const Text("Ayarları Aç"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }
}
