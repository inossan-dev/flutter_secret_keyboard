import 'package:flutter/material.dart';

class BorderAnimationEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color borderColor;
  final double borderWidth;
  final Duration duration;
  final BorderRadius borderRadius;
  final Color? backgroundColor;

  const BorderAnimationEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.borderColor = Colors.orange,
    this.borderWidth = 2.0,
    this.duration = const Duration(milliseconds: 150),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor,
  });

  @override
  State<BorderAnimationEffect> createState() => _BorderAnimationEffectState();
}

class _BorderAnimationEffectState extends State<BorderAnimationEffect> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: widget.duration,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          border: Border.all(
            color: _isPressed ? widget.borderColor : Colors.transparent,
            width: widget.borderWidth,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
