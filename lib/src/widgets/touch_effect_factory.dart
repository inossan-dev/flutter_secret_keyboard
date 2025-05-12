import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';
import 'package:flutter_secret_keyboard/src/widgets/animations/blur_effect.dart';
import 'package:flutter_secret_keyboard/src/widgets/animations/border_animation_effect.dart';
import 'package:flutter_secret_keyboard/src/widgets/animations/color_change_effect.dart';
import 'package:flutter_secret_keyboard/src/widgets/animations/elevation_effect.dart';
import 'package:flutter_secret_keyboard/src/widgets/animations/scale_button_effect.dart';
import 'package:flutter_secret_keyboard/src/widgets/animations/jelly_effect.dart';

/// Interface abstraite pour les créateurs d'effets tactiles
abstract class TouchEffectBuilder {
  /// Construit le widget avec l'effet tactile approprié
  Widget build({
    required Widget child,
    required VoidCallback onTap,
    required SecretKeyboardStyle style,
  });
}

/// Créateur d'effet tactile vide (aucun effet)
class NoneTouchEffectBuilder implements TouchEffectBuilder {
  @override
  Widget build({
    required Widget child,
    required VoidCallback onTap,
    required SecretKeyboardStyle style,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}

/// Créateur d'effet tactile Ripple
class RippleTouchEffectBuilder implements TouchEffectBuilder {
  @override
  Widget build({
    required Widget child,
    required VoidCallback onTap,
    required SecretKeyboardStyle style,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: style.touchEffectColor?.withValues(alpha: 0.3) ??
          style.indicatorActiveColor.withValues(alpha: 0.3),
      highlightColor: style.touchEffectColor?.withValues(alpha: 0.1) ??
          style.indicatorActiveColor.withValues(alpha: 0.1),
      borderRadius: style.borderRadius,
      child: child,
    );
  }
}

/// Créateur d'effet tactile Scale
class ScaleTouchEffectBuilder implements TouchEffectBuilder {
  @override
  Widget build({
    required Widget child,
    required VoidCallback onTap,
    required SecretKeyboardStyle style,
  }) {
    return ScaleButtonEffect(
      onTap: onTap,
      duration: style.touchEffectDuration,
      scaleValue: style.touchEffectScaleValue,
      child: child,
    );
  }
}

/// Créateur d'effet tactile Color
class ColorTouchEffectBuilder implements TouchEffectBuilder {
  @override
  Widget build({
    required Widget child,
    required VoidCallback onTap,
    required SecretKeyboardStyle style,
  }) {
    return ColorChangeEffect(
      onTap: onTap,
      normalColor: style.backgroundColor,
      pressedColor: style.touchEffectColor?.withValues(alpha: 0.3) ??
          Colors.grey.shade300,
      duration: style.touchEffectDuration,
      borderRadius: style.borderRadius,
      child: child,
    );
  }
}

/// Créateur d'effet tactile Elevation
class ElevationTouchEffectBuilder implements TouchEffectBuilder {
  @override
  Widget build({
    required Widget child,
    required VoidCallback onTap,
    required SecretKeyboardStyle style,
  }) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevationEffect(
        onTap: onTap,
        backgroundColor: style.backgroundColor,
        duration: style.touchEffectDuration,
        borderRadius: style.borderRadius,
        child: child,
      ),
    );
  }
}

/// Créateur d'effet tactile Border
class BorderTouchEffectBuilder implements TouchEffectBuilder {
  @override
  Widget build({
    required Widget child,
    required VoidCallback onTap,
    required SecretKeyboardStyle style,
  }) {
    return BorderAnimationEffect(
      onTap: onTap,
      backgroundColor: style.backgroundColor,
      borderColor: style.touchEffectColor ?? style.indicatorActiveColor,
      duration: style.touchEffectDuration,
      borderRadius: style.borderRadius,
      child: child,
    );
  }
}

/// Créateur d'effet tactile Blur
class BlurTouchEffectBuilder implements TouchEffectBuilder {
  @override
  Widget build({
    required Widget child,
    required VoidCallback onTap,
    required SecretKeyboardStyle style,
  }) {
    return BlurKeyEffect(
      onTap: onTap,
      maxBlurIntensity: style.blurIntensity,
      blurDuration: style.blurDuration,
      enabled: style.blurEnabled,
      child: child,
    );
  }
}

/// Créateur d'effet tactile Jelly
class JellyTouchEffectBuilder implements TouchEffectBuilder {
  @override
  Widget build({
    required Widget child,
    required VoidCallback onTap,
    required SecretKeyboardStyle style,
  }) {
    return JellyEffect(
      onTap: onTap,
      duration: style.touchEffectDuration,
      jellyStrength: style.touchEffectScaleValue * 0.2, // Utilise le scaleValue pour l'intensité
      child: child,
    );
  }
}

/// Factory pour créer les builders d'effets tactiles
class TouchEffectFactory {
  /// Registre des builders pour chaque type d'effet
  static final Map<KeyTouchEffect, TouchEffectBuilder> _builders = {
    KeyTouchEffect.none: NoneTouchEffectBuilder(),
    KeyTouchEffect.ripple: RippleTouchEffectBuilder(),
    KeyTouchEffect.scale: ScaleTouchEffectBuilder(),
    KeyTouchEffect.color: ColorTouchEffectBuilder(),
    KeyTouchEffect.elevation: ElevationTouchEffectBuilder(),
    KeyTouchEffect.border: BorderTouchEffectBuilder(),
    KeyTouchEffect.blur: BlurTouchEffectBuilder(),
    KeyTouchEffect.jelly: JellyTouchEffectBuilder(),
  };

  /// Obtient le builder approprié pour un type d'effet donné
  static TouchEffectBuilder getBuilder(KeyTouchEffect effect) {
    final builder = _builders[effect];
    if (builder == null) {
      throw ArgumentError('Effet tactile non supporté: $effect');
    }
    return builder;
  }

  /// Crée un widget avec l'effet tactile spécifié
  static Widget createTouchEffectWidget({
    required KeyTouchEffect effect,
    required Widget child,
    required VoidCallback onTap,
    required SecretKeyboardStyle style,
  }) {
    final builder = getBuilder(effect);
    return builder.build(
      child: child,
      onTap: onTap,
      style: style,
    );
  }
}