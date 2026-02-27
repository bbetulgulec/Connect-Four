import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String title;
  final String fontFamily;
  final Color textColor;
  final List<Shadow>? shadows;
  final List<FontFeature>? fontFeatures;
  final ValueNotifier<int>? notifier;

  const TextTitle({
    super.key,
    required this.title,
    this.fontFamily = "Nunito",
    this.textColor = Colors.white,
    this.fontFeatures,
    this.notifier,
    this.shadows,
  });

  factory TextTitle.nunito({required String title}) {
    return TextTitle(title: title, fontFamily: "Nunito");
  }

  factory TextTitle.futu({
    String title = "",
    Color color = Colors.white,
    ValueNotifier<int>? notifier,
  }) {
    return TextTitle(
      title: title,
      fontFamily: "Orbitron",
      textColor: color,
      fontFeatures: const [FontFeature.slashedZero()],
      notifier: notifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (notifier != null) {
      return ValueListenableBuilder<int>(
        valueListenable: notifier!,
        builder: (context, value, child) {
          // Zengin metin yapısı: Başlık ve Sayı farklı stillerde
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                fontFamily: "Nunito", // Sabit Nunito başlık
                color: Colors.white, // Sabit Beyaz başlık
              ),
              children: [
                TextSpan(text: title), // Örn: "SCORE: "
                TextSpan(
                  text: " $value", // Örn: " 120"
                  style: TextStyle(
                    fontFamily: "Orbitron", // Sayı için fütüristik font
                    color: textColor, // Factory'den gelen sarı/mavi renk
                    fontFeatures: fontFeatures,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    return _buildText(title);
  }

  Widget _buildText(String content) {
    return Text(
      content,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontFamily: fontFamily,
        color: textColor,
        fontSize: 22,
        fontFeatures: fontFeatures,
        letterSpacing: fontFamily == "Orbitron" ? 2.0 : null,
      ),
    );
  }
}
