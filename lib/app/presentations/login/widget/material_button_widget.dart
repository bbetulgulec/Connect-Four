import 'package:flutter/material.dart';

class MaterialButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;

  const MaterialButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),

                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
