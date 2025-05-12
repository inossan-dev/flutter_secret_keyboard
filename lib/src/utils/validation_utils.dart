import 'package:flutter_secret_keyboard/src/exceptions/exceptions.dart';

/// Utilitaire de validation centralisé avec gestion d'erreurs cohérente
class ValidationUtils {
  /// Valide le nombre de colonnes de la grille
  static int validateGridColumns(int gridColumns, {String parameterName = 'gridColumns'}) {
    const validValues = [3, 4];

    try {
      ErrorHandler().validateParameter(
        parameterName: parameterName,
        value: gridColumns,
        validator: (value) => validValues.contains(value),
        expectedDescription: 'soit 3 ou 4',
      );
      return gridColumns;
    } catch (e) {
      ErrorHandler().handleError(e as Exception);
      rethrow;
    }
  }

  /// Valide la longueur maximale du code
  static int validateMaxLength(int maxLength, {String parameterName = 'maxLength'}) {
    try {
      ErrorHandler().validateParameter(
        parameterName: parameterName,
        value: maxLength,
        validator: (value) => value >= 1 && value <= 20,
        expectedDescription: 'un entier entre 1 et 20',
      );
      return maxLength;
    } catch (e) {
      ErrorHandler().handleError(e as Exception);
      rethrow;
    }
  }

  /// Valide qu'une chaîne n'est pas vide
  static String validateNonEmptyString(String value, {String parameterName = 'value'}) {
    try {
      ErrorHandler().validateParameter(
        parameterName: parameterName,
        value: value,
        validator: (val) => val != null && val.toString().isNotEmpty,
        expectedDescription: 'une chaîne non vide',
      );
      return value;
    } catch (e) {
      ErrorHandler().handleError(e as Exception);
      rethrow;
    }
  }

  /// Valide un widget callback optionnel
  static T? validateOptionalCallback<T extends Function>(T? callback, {String parameterName = 'callback'}) {
    if (callback == null) return null;

    try {
      return callback;
    } catch (e) {
      ErrorHandler().handleError(e as Exception);
      rethrow;
    }
  }

  /// Valide une plage numérique
  static num validateRange({
    required num value,
    required num min,
    required num max,
    required String parameterName,
  }) {
    try {
      ErrorHandler().validateParameter(
        parameterName: parameterName,
        value: value,
        validator: (val) => val >= min && val <= max,
        expectedDescription: 'une valeur entre $min et $max',
      );
      return value;
    } catch (e) {
      ErrorHandler().handleError(e as Exception);
      rethrow;
    }
  }

  /// Valide un enum
  static T validateEnum<T extends Enum>({
    required T value,
    required List<T> validValues,
    required String parameterName,
  }) {
    try {
      ErrorHandler().validateParameter(
        parameterName: parameterName,
        value: value,
        validator: (val) => validValues.contains(val),
        expectedDescription: 'l\'une des valeurs suivantes: ${validValues.join(", ")}',
      );
      return value;
    } catch (e) {
      ErrorHandler().handleError(e as Exception);
      rethrow;
    }
  }

  /// Méthode générique pour exécuter une validation avec gestion d'erreur
  static T safeValidate<T>({
    required T Function() validation,
    required T defaultValue,
    String? context,
  }) {
    return ErrorHandler().safeExecute(
      action: validation,
      defaultValue: defaultValue,
      errorContext: context,
    );
  }
}