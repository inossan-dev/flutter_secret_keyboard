/// Constantes utilisées dans la bibliothèque de clavier secret
class SecretKeyboardConstants {
  /// Longueur par défaut du code PIN
  static const int PIN_CODE_LENGTH = 4;

  /// Constante représentant la touche de suppression
  static const String DELETE_KEY = "D";

  /// Constante représentant la touche d'empreinte digitale
  static const String FINGERPRINT_KEY = "P";

  /// Constante représentant une touche vide
  static const String EMPTY_KEY = "";
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
  border
}