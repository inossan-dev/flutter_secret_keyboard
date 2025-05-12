import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/src/constants/secret_keyboard_constants.dart';
import 'package:flutter_secret_keyboard/src/models/secret_keyboard_data.dart';

/// Utilitaire de migration pour faciliter la transition vers la nouvelle nomenclature
class KeyMigrationHelper {
  /// Convertit les anciens codes de touches vers la nouvelle nomenclature
  static SecretKeyboardData migrateKeyData(String oldKey) {
    final normalizedKey = SecretKeyboardConstants.convertLegacyKey(oldKey);

    switch (normalizedKey) {
      case SecretKeyboardConstants.DELETE_KEY:
        return SecretKeyboardData.delete();
      case SecretKeyboardConstants.FINGERPRINT_KEY:
        return SecretKeyboardData.fingerprint();
      case SecretKeyboardConstants.EMPTY_KEY:
        return SecretKeyboardData.empty();
      default:
        if (SecretKeyboardConstants.isNumericKey(normalizedKey)) {
          return SecretKeyboardData.numeric(normalizedKey);
        }
        return SecretKeyboardData(key: normalizedKey);
    }
  }

  /// Migre une liste complète de touches
  static List<SecretKeyboardData> migrateKeyboardData(List<String> oldKeys) {
    return oldKeys.map((key) => migrateKeyData(key)).toList();
  }

  /// Vérifie si une clé utilise l'ancienne nomenclature
  static bool isLegacyKey(String key) {
    return SecretKeyboardConstants.legacyKeyMappings.containsKey(key);
  }

  /// Affiche un avertissement si des clés héritées sont détectées
  static void checkForLegacyKeys(List<String> keys) {
    final legacyKeys = keys.where((key) => isLegacyKey(key)).toList();

    if (legacyKeys.isNotEmpty) {
      debugPrint(
          'Attention: Des clés héritées ont été détectées: $legacyKeys. '
              'Considérez la migration vers la nouvelle nomenclature pour une meilleure maintenabilité.'
      );
    }
  }
}