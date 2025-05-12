import 'package:flutter_secret_keyboard/src/constants/secret_keyboard_constants.dart';

/// Énumération des types de touches
enum KeyType {
  numeric,
  delete,
  fingerprint,
  empty,
  custom,
}

/// Classe améliorée représentant une touche sur le clavier secret
class SecretKeyboardData {
  /// Valeur de la touche
  final String key;

  /// Type de touche pour une identification claire
  final KeyType type;

  /// Label d'affichage (optionnel)
  final String? displayLabel;

  SecretKeyboardData({
    required this.key,
    KeyType? type,
    this.displayLabel,
  }) : type = type ?? _determineKeyType(key);

  /// Détermine automatiquement le type de touche
  static KeyType _determineKeyType(String key) {
    final normalizedKey = SecretKeyboardConstants.convertLegacyKey(key);

    if (SecretKeyboardConstants.isNumericKey(normalizedKey)) {
      return KeyType.numeric;
    } else if (normalizedKey == SecretKeyboardConstants.DELETE_KEY) {
      return KeyType.delete;
    } else if (normalizedKey == SecretKeyboardConstants.FINGERPRINT_KEY) {
      return KeyType.fingerprint;
    } else if (normalizedKey == SecretKeyboardConstants.EMPTY_KEY) {
      return KeyType.empty;
    }

    return KeyType.custom;
  }

  /// Constructeur pour une touche numérique
  factory SecretKeyboardData.numeric(String digit) {
    assert(RegExp(r'^[0-9]$').hasMatch(digit), 'Le chiffre doit être entre 0 et 9');
    return SecretKeyboardData(
      key: digit,
      type: KeyType.numeric,
    );
  }

  /// Constructeur pour la touche de suppression
  factory SecretKeyboardData.delete() {
    return SecretKeyboardData(
      key: SecretKeyboardConstants.DELETE_KEY,
      type: KeyType.delete,
      displayLabel: "Supprimer",
    );
  }

  /// Constructeur pour la touche d'empreinte digitale
  factory SecretKeyboardData.fingerprint() {
    return SecretKeyboardData(
      key: SecretKeyboardConstants.FINGERPRINT_KEY,
      type: KeyType.fingerprint,
      displayLabel: "Empreinte digitale",
    );
  }

  /// Constructeur pour une touche vide
  factory SecretKeyboardData.empty() {
    return SecretKeyboardData(
      key: SecretKeyboardConstants.EMPTY_KEY,
      type: KeyType.empty,
    );
  }
}
