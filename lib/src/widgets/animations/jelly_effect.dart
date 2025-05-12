import 'package:flutter/material.dart';

/// Effet gélatineux qui donne une impression de déformation élastique
class JellyEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Duration duration;
  final double jellyStrength;

  const JellyEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.duration = const Duration(milliseconds: 400),
    this.jellyStrength = 0.15,
  });

  @override
  State<JellyEffect> createState() => _JellyEffectState();
}

class _JellyEffectState extends State<JellyEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _translationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Animation d'échelle avec effet élastique
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0 - widget.jellyStrength)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
            begin: 1.0 - widget.jellyStrength,
            end: 1.0 + widget.jellyStrength * 0.6)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
            begin: 1.0 + widget.jellyStrength * 0.6, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticIn)),
        weight: 30,
      ),
    ]).animate(_controller);

    // Animation de rotation subtile
    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: widget.jellyStrength * 0.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
            begin: widget.jellyStrength * 0.1,
            end: -widget.jellyStrength * 0.05)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
            begin: -widget.jellyStrength * 0.05, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticIn)),
        weight: 25,
      ),
    ]).animate(_controller);

    // Animation de translation légère pour un effet de rebond
    _translationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -widget.jellyStrength * 5)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
            begin: -widget.jellyStrength * 5,
            end: widget.jellyStrength * 3)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.jellyStrength * 3, end: 0.0)
            .chain(CurveTween(curve: Curves.bounceIn)),
        weight: 20,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..translate(0.0, _translationAnimation.value)
              ..rotateZ(_rotationAnimation.value)
              ..scale(
                _scaleAnimation.value,
                _scaleAnimation.value * (1.0 + _rotationAnimation.value.abs()),
              ),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
