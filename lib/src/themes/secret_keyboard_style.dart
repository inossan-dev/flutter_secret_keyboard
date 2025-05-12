import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

/// Configuration complète des styles pour le clavier secret
class SecretKeyboardStyle {
  // Styles de texte
  final TextStyle cellTextStyle;
  final TextStyle? deleteIconStyle;
  final TextStyle? fingerprintIconStyle;

  // Couleurs
  final Color backgroundColor;
  final Color indicatorActiveColor;
  final Color indicatorInactiveColor;
  final Color indicatorBackgroundColor;

  // Effets tactiles
  final KeyTouchEffect touchEffect;
  final Color? touchEffectColor;
  final Duration touchEffectDuration;
  final double touchEffectScaleValue;

  // Bordures
  final bool showBorders;
  final bool showOuterBorder;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;

  // Effet de flou
  final double blurIntensity;
  final Duration blurDuration;
  final bool blurEnabled;

  // Layout
  final double cellAspectRatio;
  final double horizontalPadding;
  final double indicatorSize;
  final double borderPadding;

  const SecretKeyboardStyle({
    this.cellTextStyle = const TextStyle(
      fontSize: 25,
      color: Colors.black,
      fontWeight: FontWeight.normal,
    ),
    this.deleteIconStyle,
    this.fingerprintIconStyle,
    this.backgroundColor = Colors.white,
    this.indicatorActiveColor = Colors.orange,
    this.indicatorInactiveColor = Colors.black,
    this.indicatorBackgroundColor = Colors.white,
    this.touchEffect = KeyTouchEffect.none,
    this.touchEffectColor,
    this.touchEffectDuration = const Duration(milliseconds: 150),
    this.touchEffectScaleValue = 0.95,
    this.showBorders = false,
    this.showOuterBorder = false,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.blurIntensity = BlurEffectConstants.DEFAULT_BLUR_INTENSITY,
    this.blurDuration = BlurEffectConstants.DEFAULT_BLUR_DURATION,
    this.blurEnabled = true,
    this.cellAspectRatio = 1.0,
    this.horizontalPadding = 100,
    this.indicatorSize = 20,
    this.borderPadding = 1,
  });

  /// Fusionne ce style avec un autre, en donnant priorité à l'autre style
  SecretKeyboardStyle merge(SecretKeyboardStyle? other) {
    if (other == null) return this;

    // Toutes les propriétés de 'other' ont la priorité
    return SecretKeyboardStyle(
      cellTextStyle: other.cellTextStyle,
      deleteIconStyle: other.deleteIconStyle ?? deleteIconStyle,
      fingerprintIconStyle: other.fingerprintIconStyle ?? fingerprintIconStyle,
      backgroundColor: other.backgroundColor,
      indicatorActiveColor: other.indicatorActiveColor,
      indicatorInactiveColor: other.indicatorInactiveColor,
      indicatorBackgroundColor: other.indicatorBackgroundColor,
      touchEffect: other.touchEffect,
      touchEffectColor: other.touchEffectColor ?? touchEffectColor,
      touchEffectDuration: other.touchEffectDuration,
      touchEffectScaleValue: other.touchEffectScaleValue,
      showBorders: other.showBorders,
      showOuterBorder: other.showOuterBorder,
      borderColor: other.borderColor ?? borderColor,
      borderWidth: other.borderWidth,
      borderRadius: other.borderRadius,
      blurIntensity: other.blurIntensity,
      blurDuration: other.blurDuration,
      blurEnabled: other.blurEnabled,
      cellAspectRatio: other.cellAspectRatio,
      horizontalPadding: other.horizontalPadding,
      indicatorSize: other.indicatorSize,
      borderPadding: other.borderPadding,
    );
  }

  /// Nouvelle méthode pour appliquer des personnalisations partielles
  SecretKeyboardStyle copyWith({
    TextStyle? cellTextStyle,
    TextStyle? deleteIconStyle,
    TextStyle? fingerprintIconStyle,
    Color? backgroundColor,
    Color? indicatorActiveColor,
    Color? indicatorInactiveColor,
    Color? indicatorBackgroundColor,
    KeyTouchEffect? touchEffect,
    Color? touchEffectColor,
    Duration? touchEffectDuration,
    double? touchEffectScaleValue,
    bool? showBorders,
    bool? showOuterBorder,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    double? blurIntensity,
    Duration? blurDuration,
    bool? blurEnabled,
    double? cellAspectRatio,
    double? horizontalPadding,
    double? indicatorSize,
    double? borderPadding,
  }) {
    return SecretKeyboardStyle(
      cellTextStyle: cellTextStyle ?? this.cellTextStyle,
      deleteIconStyle: deleteIconStyle ?? this.deleteIconStyle,
      fingerprintIconStyle: fingerprintIconStyle ?? this.fingerprintIconStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      indicatorActiveColor: indicatorActiveColor ?? this.indicatorActiveColor,
      indicatorInactiveColor: indicatorInactiveColor ?? this.indicatorInactiveColor,
      indicatorBackgroundColor: indicatorBackgroundColor ?? this.indicatorBackgroundColor,
      touchEffect: touchEffect ?? this.touchEffect,
      touchEffectColor: touchEffectColor ?? this.touchEffectColor,
      touchEffectDuration: touchEffectDuration ?? this.touchEffectDuration,
      touchEffectScaleValue: touchEffectScaleValue ?? this.touchEffectScaleValue,
      showBorders: showBorders ?? this.showBorders,
      showOuterBorder: showOuterBorder ?? this.showOuterBorder,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      blurIntensity: blurIntensity ?? this.blurIntensity,
      blurDuration: blurDuration ?? this.blurDuration,
      blurEnabled: blurEnabled ?? this.blurEnabled,
      cellAspectRatio: cellAspectRatio ?? this.cellAspectRatio,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      indicatorSize: indicatorSize ?? this.indicatorSize,
      borderPadding: borderPadding ?? this.borderPadding,
    );
  }
}
