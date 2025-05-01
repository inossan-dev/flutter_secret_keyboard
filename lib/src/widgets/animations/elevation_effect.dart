import 'package:flutter/material.dart';

class ElevationEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double normalElevation;
  final double pressedElevation;
  final Duration duration;
  final BorderRadius borderRadius;
  final Color? backgroundColor;

  const ElevationEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.normalElevation = 4.0,
    this.pressedElevation = 1.0,
    this.duration = const Duration(milliseconds: 150),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor,
  });

  @override
  State<ElevationEffect> createState() => _ElevationEffectState();
}

class _ElevationEffectState extends State<ElevationEffect> {
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 0.5,
              blurRadius: _isPressed ? widget.pressedElevation : widget.normalElevation,
              offset: Offset(0, _isPressed ? 1 : 2),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}