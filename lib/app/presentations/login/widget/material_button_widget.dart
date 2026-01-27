import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

class MaterialButtonWidget extends StatefulWidget {
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
  State<MaterialButtonWidget> createState() => _MaterialButtonWidgetState();
}

class _MaterialButtonWidgetState extends State<MaterialButtonWidget> {
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),

                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () async {
              final box = Hive.box<bool>('vibration');
              final isVibrationEnabled =
                  box.get('enabled', defaultValue: true) ?? true;

              if (isVibrationEnabled && await Vibration.hasVibrator() == true) {
                await Vibration.vibrate(preset: VibrationPreset.longAlarmBuzz);
              }

              if (widget.onPressed != null) {
                widget.onPressed!();
              }
            },

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
              widget.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
