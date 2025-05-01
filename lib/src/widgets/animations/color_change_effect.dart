import 'package:flutter/material.dart';

class ColorChangeEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? normalColor;
  final Color pressedColor;
  final Duration duration;
  final BorderRadius borderRadius;

  const ColorChangeEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.normalColor,
    this.pressedColor = const Color(0xFFE0E0E0),
    this.duration = const Duration(milliseconds: 150),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  State<ColorChangeEffect> createState() => _ColorChangeEffectState();
}

class _ColorChangeEffectState extends State<ColorChangeEffect> {
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
          color: _isPressed ? widget.pressedColor : widget.normalColor,
          borderRadius: widget.borderRadius,
        ),
        child: widget.child,
      ),
    );
  }
}
