import 'dart:ui';

import 'package:connect_four/app/presentations/login/widget/switch_widget.dart';
import 'package:connect_four/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key});

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  bool isMuted = false; // switch durumu
  late Box<bool> voiceBox; // box referansı

  @override
  void initState() {
    super.initState();

    // Hive box aç
    Hive.openBox<bool>('voice').then((box) {
      voiceBox = box;

      // Hive'dan switch durumunu al
      setState(() {
        isMuted = voiceBox.get('enabled', defaultValue: false) ?? false;
      });
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
                // Başlık ve kapatma butonu
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Ayarlar",
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 25,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close, color: Colors.white60, size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Bildirim Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Bildirimler :",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Spacer(),
                    SwitchWidget(value: false, onChanged: (bool value) {}),
                  ],
                ),

                // SES SWITCH
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Sesler :",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Spacer(),
                    SwitchWidget(
                      value: isMuted,
                      onChanged: (bool value) async {
                        setState(() {
                          isMuted = value;
                          voiceBox.put('enabled', value); // Hive’e kaydet
                        });

                        if (value) {
                          await mainPlayer.setVolume(0.0);
                          await mainPlayer.pause(); // opsiyonel: durdurmak için
                        } else {
                          await mainPlayer.setVolume(1.0);
                          await mainPlayer.resume(); // direkt çağır
                        }
                      },
                    ),
                  ],
                ),

                // Titreşimler Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Titreşimler :",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Spacer(),
                    SwitchWidget(value: false, onChanged: (bool value) {}),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
