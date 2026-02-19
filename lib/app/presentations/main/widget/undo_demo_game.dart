import 'package:connect_four/app/presentations/main/component/demo_piece.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class UndoDemoGame extends FlameGame {
  late DemoPiece bluePiece;
  DemoPiece? redPiece; // Null-safety için güncelledik

 final Vector2 spawnPos = Vector2(80, -60); 
  final Vector2 bluePos = Vector2(80, 150); 
  
  // DEĞİŞEN KISIM BURASI: 
  // Mavi 150'de, top çapı 40 olduğu için 150 - 40 = 110 tam üst sınırı olur.
  final Vector2 redTargetPos = Vector2(80, 110);

  @override
  Future<void> onLoad() async {
    _setup();
  }

  @override
  Color backgroundColor() => Colors.white; // Veya Colors.transparent

  void _setup() {
    // Önceki her şeyi temizle
    removeAll(children.whereType<DemoPiece>());

    // Mavi sabit duruyor
    bluePiece = DemoPiece(player: 2, position: bluePos);
    add(bluePiece);

    // 1 saniye sonra hatalı hamle başlasın
    Future.delayed(const Duration(seconds: 1), _dropWrongPiece);
  }

  void _dropWrongPiece() {
    redPiece = DemoPiece(player: 1, position: spawnPos.clone());
    add(redPiece!);

    // Aşağı düşüş
    redPiece!.add(
      MoveEffect.to(
        redTargetPos,
        EffectController(duration: 0.5, curve: Curves.bounceOut),
        onComplete: () {
          // Düştükten sonra biraz bekle ve geri çek (Undo)
          Future.delayed(const Duration(milliseconds: 1000), _undoLastMove);
        },
      ),
    );
  }

  void _undoLastMove() {
    if (redPiece == null) return;

    // 1. Üzerindeki tüm eski hareketleri durdur (Çakışmayı önler)
    redPiece!.removeAll(redPiece!.children.whereType<Effect>());

    // 2. Yukarı fırlatma efekti
    redPiece!.add(
      MoveEffect.to(
        Vector2(80, -100), // Ekranın tamamen dışına (yukarı) gönder
        EffectController(
          duration: 0.6,
          curve: Curves.easeInBack, // Önce esner, sonra yukarı fırlar
        ),
        onComplete: () {
          redPiece!.removeFromParent();
          redPiece = null;
          Future.delayed(const Duration(seconds: 1), _setup);
        },
      ),
    );

    // 3. Opsiyonel: Yukarı giderken küçülerek kaybolsun
    redPiece!.add(
      ScaleEffect.to(Vector2.all(0.5), EffectController(duration: 0.4)),
    );
  }
}
