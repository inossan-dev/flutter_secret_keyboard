/// Constantes améliorées pour le clavier secret avec nomenclature explicite
class SecretKeyboardConstants {
  /// Constante représentant la touche de suppression
  static const String DELETE_KEY = "DELETE";

  /// Constante représentant la touche d'empreinte digitale
  static const String FINGERPRINT_KEY = "FINGERPRINT";

  /// Constante représentant une touche vide
  static const String EMPTY_KEY = "EMPTY";

  /// Longueur par défaut du code PIN
  static const int PIN_CODE_LENGTH = 4;

  // Mappings pour la rétrocompatibilité
  static const Map<String, String> legacyKeyMappings = {
    "D": DELETE_KEY,
    "P": FINGERPRINT_KEY,
    "E": EMPTY_KEY,
  };

  // Touches numériques
  static const String KEY_0 = "0";
  static const String KEY_1 = "1";
  static const String KEY_2 = "2";
  static const String KEY_3 = "3";
  static const String KEY_4 = "4";
  static const String KEY_5 = "5";
  static const String KEY_6 = "6";
  static const String KEY_7 = "7";
  static const String KEY_8 = "8";
  static const String KEY_9 = "9";

  /// Méthode de conversion pour gérer la rétrocompatibilité
  static String convertLegacyKey(String key) {
    return legacyKeyMappings[key] ?? key;
  }

  /// Vérifie si une clé est une touche spéciale
  static bool isSpecialKey(String key) {
    return key == DELETE_KEY ||
        key == FINGERPRINT_KEY ||
        key == EMPTY_KEY;
  }

  /// Vérifie si une clé est numérique
  static bool isNumericKey(String key) {
    return RegExp(r'^[0-9]$').hasMatch(key);
  }
}

// Alias pour la rétrocompatibilité (à déprécier progressivement)
@Deprecated('Utilisez SecretKeyboardConstants à la place')
class LegacyKeyboardConstants {
  static const String DELETE_KEY = "D";
  static const String FINGERPRINT_KEY = "P";
}