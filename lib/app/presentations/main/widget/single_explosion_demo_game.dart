import 'package:connect_four/app/presentations/main/component/demo_piece.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class SingleExplosionDemoGame extends FlameGame {
  late DemoPiece bluePiece; 
  late DemoPiece yellowPiece; 

  @override
  Future<void> onLoad() async {
    _setup();
  }

  @override
  Color backgroundColor() => Colors.white; 

  void _setup() {
    // Varsa eski parçaları temizle (Tekrar oynatma için)
    removeAll(children.whereType<DemoPiece>());

    // 1. Taşları sabit pozisyonlarda oluştur (Gökten düşme yok)
    // Mavi Üstte (Y: 80)
    bluePiece = DemoPiece(player: 2, position: Vector2(80, 60));
    // Sarı Altta (Y: 140) - Arada 60 birim fark var
    yellowPiece = DemoPiece(player: 1, position: Vector2(80, 100));

    add(bluePiece);
    add(yellowPiece);

    // 1 saniye bekle ve patlama serisini başlat
    Future.delayed(const Duration(seconds: 1), () {
      _startExplosion();
    });
  }

  void _startExplosion() {
    // 1. ADIM: Sarı parça şişer
    yellowPiece.add(
      ScaleEffect.to(
        Vector2.all(1.4),
        EffectController(duration: 0.2, curve: Curves.easeOut),
        onComplete: () {
          // 2. ADIM: Sarı parça küçülerek yok olur
          yellowPiece.add(
            ScaleEffect.to(
              Vector2.zero(),
              EffectController(duration: 0.15, curve: Curves.easeIn),
              onComplete: () {
                yellowPiece.removeFromParent(); // Ekrandan tamamen kaldır

                // 3. ADIM: Mavi parça sarının eski yerine düşer
                _moveBlueDown();
              },
            ),
          );
        },
      ),
    );
  }

  void _moveBlueDown() {
    // Mavinin yeni hedefi sarının başlangıç noktası (Y: 140)
    bluePiece.add(
      MoveEffect.to(
        Vector2(80, 140),
        EffectController(duration: 0.4, curve: Curves.easeIn),
      ),
    );

    // Demosu sonsuz döngüye sokmak istersen:
    Future.delayed(const Duration(seconds: 2), _setup);
  }
}
