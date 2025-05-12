import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Effet de particules qui génère une explosion de particules colorées au clic
class ParticleEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Duration duration;
  final int particleCount;
  final Color particleColor;
  final double particleSize;

  const ParticleEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.duration = const Duration(milliseconds: 800),
    this.particleCount = 12,
    this.particleColor = Colors.orange,
    this.particleSize = 3.0,
  });

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {
        for (var particle in _particles) {
          particle.update(_controller.value);
        }
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _particles.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();

    setState(() {
      _particles = List.generate(
        widget.particleCount,
            (index) => Particle(
          position: const Offset(0, 0),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 200,
            (_random.nextDouble() - 0.5) * 200,
          ),
          size: widget.particleSize,
          color: widget.particleColor.withValues(
            alpha: widget.particleColor.a * (0.5 + _random.nextDouble() * 0.5),
          ),
          lifespan: 0.5 + _random.nextDouble() * 0.5,
        ),
      );
    });

    _controller.forward(from: 0);
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
        if (_particles.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: ParticlePainter(particles: _particles),
                size: Size.infinite,
              ),
            ),
          ),
      ],
    );
  }
}

class Particle {
  Offset position;
  final Offset velocity;
  final double size;
  final Color color;
  final double lifespan;
  double opacity = 1.0;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    required this.lifespan,
  });

  void update(double progress) {
    position = Offset(
      velocity.dx * progress,
      velocity.dy * progress + 50 * progress * progress, // Gravité
    );

    if (progress > lifespan) {
      opacity = math.max(0, 1 - (progress - lifespan) / (1 - lifespan));
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.color.a * particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        center + particle.position,
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}