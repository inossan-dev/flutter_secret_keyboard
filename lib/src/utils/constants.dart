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