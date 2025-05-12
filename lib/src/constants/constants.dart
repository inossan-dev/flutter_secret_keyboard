import 'package:flutter/material.dart';

/// Centralisation de toutes les valeurs par défaut du package
class DefaultValues {
  // Ne pas instancier cette classe
  const DefaultValues._();

  // === Layout et dimensions ===
  static const int gridColumns = 4;
  static const int codeLength = 4;
  static const double horizontalPadding = 100.0;
  static const double indicatorSize = 20.0;
  static const double borderPadding = 1.0;
  static const double cellAspectRatio = 1.0;
  static const double borderWidth = 1.0;

  // === Couleurs principales ===
  static const Color backgroundColor = Colors.white;
  static const Color indicatorActiveColor = Colors.orange;
  static const Color indicatorInactiveColor = Colors.black;
  static const Color indicatorBackgroundColor = Colors.white;
  static const Color textColor = Colors.black;

  // === Styles de texte ===
  static const TextStyle cellTextStyle = TextStyle(
    fontSize: 25,
    color: Colors.black,
    fontWeight: FontWeight.normal,
  );

  // === Options d'affichage ===
  static const bool showSecretCode = true;
  static const bool showGrid = true;
  static const bool showBorders = false;
  static const bool showOuterBorder = false;

  // === Configuration du clavier ===
  static const bool fingerprintEnabled = false;
  static const bool randomizeKeys = true;
  static const AuthenticationFunction authenticationFunction =
      AuthenticationFunction.transactionValidation;

  // === TextField binding ===
  static const bool obscureText = true;
  static const String obscuringCharacter = '•';

  // === Effets visuels ===
  static const KeyTouchEffect touchEffect = KeyTouchEffect.none;
  static const Duration touchEffectDuration = Duration(milliseconds: 150);
  static const double touchEffectScaleValue = 0.95;

  // === Effet de flou ===
  static const double blurIntensity = 3.0;
  static const Duration blurDuration = Duration(milliseconds: 300);
  static const bool blurEnabled = true;

  // === BorderRadius ===
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(12));
}

/// Configuration des dimensions par défaut
class DefaultDimensions {
  const DefaultDimensions._();

  static const double minIndicatorSize = 10.0;
  static const double maxIndicatorSize = 50.0;
  static const double minHorizontalPadding = 0.0;
  static const double maxHorizontalPadding = 200.0;
  static const double minBorderWidth = 0.5;
  static const double maxBorderWidth = 5.0;
}

/// Configuration des limites par défaut
class DefaultLimits {
  const DefaultLimits._();

  static const int minCodeLength = 1;
  static const int maxCodeLength = 20;
  static const int minGridColumns = 3;
  static const int maxGridColumns = 4;
}

/// Constantes pour l'effet de flou
class BlurEffectConstants {
  /// Intensité de flou par défaut
  static const double DEFAULT_BLUR_INTENSITY = 3.0;

  /// Durée de l'effet de flou par défaut
  static const Duration DEFAULT_BLUR_DURATION = Duration(milliseconds: 300);
}

/// Énumération des fonctions d'authentification
enum AuthenticationFunction {
  /// Authentification pour valider une transaction
  transactionValidation,

  /// Authentification pour se connecter
  login,

  /// Authentification pour changer le code
  changeCode,

  /// Authentification personnalisée
  custom
}

/// Type d'effet tactile pour les touches du clavier
enum KeyTouchEffect {
  /// Aucun effet (comportement par défaut)
  none,

  /// Effet de vague (ripple) de Material Design
  ripple,

  /// Effet d'échelle (la touche devient légèrement plus petite)
  scale,

  /// Effet de changement de couleur
  color,

  /// Effet d'élévation/ombre
  elevation,

  /// Effet d'animation de bordure
  border,

  /// Effet de flou temporaire
  blur,
}