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