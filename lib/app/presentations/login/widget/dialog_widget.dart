import 'dart:ui';

import 'package:connect_four/app/presentations/login/widget/switch_widget.dart';
import 'package:connect_four/core/helper/nav_helper/navigation_helper.dart';
import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({super.key});

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
                    Align(
                      alignment: AlignmentGeometry.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigation.ofPop();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white60,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Bildirimler :",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Spacer(),
                    SwitchWidget(value: false, onChanged: (bool value) {}),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Text(
                      "Sesler :",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Spacer(),
                    SwitchWidget(value: true, onChanged: (bool value) {}),
                  ],
                ),

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
