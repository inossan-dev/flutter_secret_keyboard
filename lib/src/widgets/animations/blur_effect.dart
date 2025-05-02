import 'dart:ui';

import 'package:flutter/material.dart';

class BlurKeyEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double maxBlurIntensity;
  final Duration blurDuration;
  final bool enabled;

  const BlurKeyEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.maxBlurIntensity = 3.0,
    this.blurDuration = const Duration(milliseconds: 300),
    this.enabled = true,
  });

  @override
  State<BlurKeyEffect> createState() => _BlurKeyEffectState();
}

class _BlurKeyEffectState extends State<BlurKeyEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.blurDuration,
      vsync: this,
    );

    _blurAnimation = Tween<double>(
      begin: 0.0,
      end: widget.maxBlurIntensity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.enabled) {
      _controller.forward(from: 0.0);
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _blurAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.enabled && _blurAnimation.value > 0
                  ? ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: _blurAnimation.value,
                  sigmaY: _blurAnimation.value,
                ),
                child: widget.child,
              )
                  : widget.child,
            ),
          );
        },
      ),
    );
  }
}
