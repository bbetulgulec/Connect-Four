import 'package:connect_four/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class BuildArrow extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const BuildArrow({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1 : 0.3,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width12),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
