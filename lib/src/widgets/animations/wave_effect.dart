import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Effet d'onde concentrique qui crée des ondulations circulaires au clic
class WaveEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Duration duration;
  final Color waveColor;
  final int waveCount;
  final double maxRadius;

  const WaveEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.duration = const Duration(milliseconds: 600),
    this.waveColor = Colors.blue,
    this.waveCount = 3,
    this.maxRadius = 50.0,
  });

  @override
  State<WaveEffect> createState() => _WaveEffectState();
}

class _WaveEffectState extends State<WaveEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<double> _waveStartTimes = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Créer des décalages temporels pour chaque onde
    for (int i = 0; i < widget.waveCount; i++) {
      _waveStartTimes.add(i * 0.15);
    }
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
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        GestureDetector(
          onTap: _handleTap,
          child: widget.child,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(
                    progress: _animation.value,
                    waveColor: widget.waveColor,
                    waveCount: widget.waveCount,
                    maxRadius: widget.maxRadius,
                    waveStartTimes: _waveStartTimes,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  final Color waveColor;
  final int waveCount;
  final double maxRadius;
  final List<double> waveStartTimes;

  WavePainter({
    required this.progress,
    required this.waveColor,
    required this.waveCount,
    required this.maxRadius,
    required this.waveStartTimes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < waveCount; i++) {
      final waveProgress = progress - waveStartTimes[i];

      if (waveProgress > 0) {
        final adjustedProgress = math.min(waveProgress / (1 - waveStartTimes[i]), 1.0);
        final radius = maxRadius * adjustedProgress;
        final opacity = (1.0 - adjustedProgress) * 0.3;

        final paint = Paint()
          ..color = waveColor.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0 * (1.0 - adjustedProgress);

        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}