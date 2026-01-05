import 'package:flutter/material.dart';

class HomeMaterialButton extends StatelessWidget {
  const HomeMaterialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ArcadeButtonClipper(),
      child: Material(
        color: Colors.blue,
        child: InkWell(
          onTap: () {},
          child: SizedBox(
            width: 260,
            height: 70,
            child: Center(
              child: Text(
                'YENİ OYUN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ArcadeButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 18.0;
    const bottomInset = 30.0;

    final path = Path();

    path.moveTo(radius, 0);

    // ÜST
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // SAĞ YAN
    path.lineTo(size.width - bottomInset, size.height - radius);
    path.quadraticBezierTo(
      size.width - bottomInset,
      size.height,
      size.width - bottomInset - radius,
      size.height,
    );

    // ALT
    path.lineTo(bottomInset + radius, size.height);
    path.quadraticBezierTo(
      bottomInset,
      size.height,
      bottomInset,
      size.height - radius,
    );

    // SOL YAN
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(_) => false;
}
