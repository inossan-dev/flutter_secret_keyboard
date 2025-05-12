import 'package:flutter/material.dart';

/// Effet néon amélioré qui fait briller la touche comme une véritable enseigne lumineuse
class NeonEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Duration duration;
  final Color neonColor;
  final double glowIntensity;
  final double pulseIntensity;

  const NeonEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.duration = const Duration(milliseconds: 400),
    this.neonColor = Colors.cyan,
    this.glowIntensity = 25.0,
    this.pulseIntensity = 1.05,
  });

  @override
  State<NeonEffect> createState() => _NeonEffectState();
}

class _NeonEffectState extends State<NeonEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.7, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.7)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_controller);

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: widget.pulseIntensity)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.pulseIntensity, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70,
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
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF0A0A0A),  // Fond très sombre mais pas noir complet
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  // Lueur externe principale
                  BoxShadow(
                    color: widget.neonColor.withValues(alpha: 0.8 * _glowAnimation.value),
                    blurRadius: widget.glowIntensity * _glowAnimation.value,
                    spreadRadius: 3.0 * _glowAnimation.value,
                  ),
                  // Halo secondaire plus diffus
                  BoxShadow(
                    color: widget.neonColor.withValues(alpha: 0.4 * _glowAnimation.value),
                    blurRadius: widget.glowIntensity * 2 * _glowAnimation.value,
                    spreadRadius: 8.0 * _glowAnimation.value,
                  ),
                  // Lueur ambiante très large
                  BoxShadow(
                    color: widget.neonColor.withValues(alpha: 0.2 * _glowAnimation.value),
                    blurRadius: widget.glowIntensity * 3 * _glowAnimation.value,
                    spreadRadius: 12.0 * _glowAnimation.value,
                  ),
                ],
                border: Border.all(
                  color: widget.neonColor.withValues(alpha: 0.9),
                  width: 1.5,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: widget.neonColor.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: Stack(
                  children: [
                    // Contenu principal avec effet de lumière interne
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          widget.neonColor.withValues(alpha: 0.15 * _glowAnimation.value),
                          BlendMode.overlay,
                        ),
                        child: widget.child,
                      ),
                    ),
                    // Reflet supérieur pour effet de verre
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 15,
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                widget.neonColor.withValues(alpha: 0.15),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}