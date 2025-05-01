import 'package:flutter/material.dart';

class ScaleButtonEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scaleValue;
  final Duration duration;

  const ScaleButtonEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.scaleValue = 0.95,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<ScaleButtonEffect> createState() => _ScaleButtonEffectState();
}

class _ScaleButtonEffectState extends State<ScaleButtonEffect> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? widget.scaleValue : 1.0,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}
