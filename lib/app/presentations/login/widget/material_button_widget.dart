import 'package:connect_four/app/presentations/login/provider/login_provider.dart';
import 'package:connect_four/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    final provider = context.read<LoginProvider>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.height32),
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
              provider.longAlarmBuzz();
              if (widget.onPressed != null) {
                widget.onPressed!();
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: context.width40,
                vertical: context.height20,
              ),
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
