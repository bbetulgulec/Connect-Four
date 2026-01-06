import 'package:flutter/material.dart';

class HomeMaterialButton extends StatelessWidget {
  final String text;
  const HomeMaterialButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ArcadeButtonClipper(),
      child: Material(
        color: const Color.fromARGB(255, 56, 28, 105),

        //const Color(0xFFd1ffd7),
        child: InkWell(
          onTap: () {},
          child: SizedBox(
            width: 260,
            height: 70,
            child: Center(
              child: Text(
                text,
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
    const radius = 20.0;
    const bottomInset = 15.0;

    final path = Path();

    path.moveTo(radius, 0);

    // ÜST

    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // SAĞ YAN

    path.quadraticBezierTo(
      size.width - bottomInset,
      size.height,
      size.width - bottomInset - radius,
      size.height,
    );

    // ALT

    path.quadraticBezierTo(
      bottomInset,
      size.height,
      bottomInset,
      size.height - radius,
    );

    // SOL YAN

    path.quadraticBezierTo(0, 0, radius, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(_) => false;
}
