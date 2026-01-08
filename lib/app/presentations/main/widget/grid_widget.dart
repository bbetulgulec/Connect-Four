import 'package:flutter/material.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.count(
            childAspectRatio: 1,
            crossAxisCount: 6,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 1),
            children: List.generate(
              36,
              (index) => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
