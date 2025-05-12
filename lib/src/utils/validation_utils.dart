import 'package:flutter_secret_keyboard/src/exceptions/exceptions.dart';

/// Utilitaire de validation centralisé pour les paramètres
class ValidationUtils {
  /// Valide le nombre de colonnes de la grille
  static int validateGridColumns(int gridColumns, {String parameterName = 'gridColumns'}) {
    const validValues = [3, 4];

    if (!validValues.contains(gridColumns)) {
      throw InvalidParameterException(
        parameterName: parameterName,
        value: gridColumns,
        expectedValue: 'soit 3 ou 4',
      );
    }

    return gridColumns;
  }

  /// Valide la longueur maximale du code
  static int validateMaxLength(int maxLength, {String parameterName = 'maxLength'}) {
    if (maxLength < 1) {
      throw InvalidParameterException(
        parameterName: parameterName,
        value: maxLength,
        expectedValue: 'un entier positif',
      );
    }

    return maxLength;
  }

  /// Valide qu'une chaîne n'est pas vide
  static String validateNonEmptyString(String value, {String parameterName = 'value'}) {
    if (value.isEmpty) {
      throw InvalidParameterException(
        parameterName: parameterName,
        value: value,
        expectedValue: 'une chaîne non vide',
      );
    }

    return value;
  }
}