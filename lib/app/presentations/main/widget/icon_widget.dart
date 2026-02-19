import 'package:flutter/material.dart';

class IconWidget extends StatefulWidget {
  final String iconPath;
  final double size;
  final BoxFit fit;
  final VoidCallback? onTap;        
  final VoidCallback? onLongComplete; 
  final int? badgeCount;

  const IconWidget({
    super.key,
    required this.iconPath,
    this.size = 80,
    this.fit = BoxFit.contain,
    this.onTap,
    this.onLongComplete,
    this.badgeCount,
  });

  @override
  State<IconWidget> createState() => _IconWidgetState();
}

class _IconWidgetState extends State<IconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool get hasSkill => (widget.badgeCount ?? 0) > 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onLongComplete?.call();
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startLongPress() {
    if (!hasSkill) {
      _controller.forward();
    }
  }

  void _cancelLongPress() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: GestureDetector(
        onTap: hasSkill ? widget.onTap : null,
        onLongPressStart: hasSkill ? null : (_) => _startLongPress(),
        onLongPressEnd: hasSkill ? null : (_) => _cancelLongPress(),
        onLongPressCancel: hasSkill ? null : _cancelLongPress,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [

            /// ICON
            Image.asset(
              widget.iconPath,
              width: widget.size,
              height: widget.size,
              fit: widget.fit,
            ),
            if (!hasSkill)
              SizedBox(
                width: 30,
                height: 30,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, _) {
                    return CircularProgressIndicator(
                      color: Colors.white,
                      
                      value: _controller.value,
                      strokeWidth: 12,
                    );
                  },
                ),
              ),

            /// BADGE
            if (hasSkill)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints:
                      const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    widget.badgeCount! > 99
                        ? "99+"
                        : widget.badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
