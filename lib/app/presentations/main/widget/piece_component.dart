import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class PieceComponent extends SpriteComponent {
  bool isBroken = false;

  void breakPiece() {
    if (isBroken) return;
    isBroken = true;

    // Çatlama efekti
    add(
      ScaleEffect.by(
        Vector2.all(0.2),
        EffectController(duration: 0.1, alternate: true, repeatCount: 2),
      ),
    );

    // Aynı anda çalışacak efektler
    add(
      OpacityEffect.to(
        0,
        EffectController(duration: 0.4),
        onComplete: () => removeFromParent(),
      ),
    );

    add(RotateEffect.by(0.5, EffectController(duration: 0.4)));

    add(MoveByEffect(Vector2(0, 30), EffectController(duration: 0.4)));
  }
}
