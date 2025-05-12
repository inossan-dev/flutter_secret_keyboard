import 'package:flutter/foundation.dart';

/// Exception de base pour toutes les erreurs du package
abstract class SecretKeyboardException implements Exception {
  /// Message d'erreur descriptif
  final String message;

  /// Code d'erreur unique pour identification
  final String errorCode;

  /// Détails supplémentaires sur l'erreur
  final Map<String, dynamic>? details;

  const SecretKeyboardException({
    required this.message,
    required this.errorCode,
    this.details,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('$runtimeType [$errorCode]: $message');
    if (details != null && details!.isNotEmpty) {
      buffer.write('\nDetails: $details');
    }
    return buffer.toString();
  }
}

/// Exception pour les paramètres invalides
class InvalidParameterException extends SecretKeyboardException {
  /// Nom du paramètre invalide
  final String parameterName;

  /// Valeur actuelle du paramètre
  final dynamic value;

  /// Valeur ou plage attendue
  final String expectedValue;

  InvalidParameterException({
    required this.parameterName,
    required this.value,
    required this.expectedValue,
    Map<String, dynamic>? details,
  }) : super(
    message: 'Le paramètre "$parameterName" avec la valeur "$value" est invalide. Valeur attendue: $expectedValue',
    errorCode: 'INVALID_PARAMETER',
    details: {
      'parameterName': parameterName,
      'actualValue': value,
      'expectedValue': expectedValue,
      if (details != null) ...details,
    },
  );
}

/// Exception pour les erreurs de configuration
class ConfigurationException extends SecretKeyboardException {
  /// Type de configuration erronée
  final String configurationType;

  ConfigurationException({
    required String message,
    required this.configurationType,
    Map<String, dynamic>? details,
  }) : super(
    message: message,
    errorCode: 'CONFIGURATION_ERROR',
    details: {
      'configurationType': configurationType,
      if (details != null) ...details,
    },
  );
}

/// Exception pour les erreurs d'état
class StateException extends SecretKeyboardException {
  /// État actuel du système
  final String currentState;

  /// Action tentée
  final String attemptedAction;

  StateException({
    required this.currentState,
    required this.attemptedAction,
    Map<String, dynamic>? details,
  }) : super(
    message: 'Action "$attemptedAction" invalide dans l\'état actuel: $currentState',
    errorCode: 'INVALID_STATE',
    details: {
      'currentState': currentState,
      'attemptedAction': attemptedAction,
      if (details != null) ...details,
    },
  );
}

/// Exception pour les erreurs de liaison avec TextField
class TextFieldBindingException extends SecretKeyboardException {
  TextFieldBindingException({
    required String message,
    Map<String, dynamic>? details,
  }) : super(
    message: message,
    errorCode: 'TEXTFIELD_BINDING_ERROR',
    details: details,
  );
}

/// Exception pour les erreurs de rendu
class RenderException extends SecretKeyboardException {
  RenderException({
    required String message,
    Map<String, dynamic>? details,
  }) : super(
    message: message,
    errorCode: 'RENDER_ERROR',
    details: details,
  );
}

/// Exception pour les erreurs de thème/style
class ThemeException extends SecretKeyboardException {
  ThemeException({
    required String message,
    Map<String, dynamic>? details,
  }) : super(
    message: message,
    errorCode: 'THEME_ERROR',
    details: details,
  );
}

/// Gestionnaire centralisé des erreurs pour Flutter Secret Keyboard
class ErrorHandler {
  /// Instance singleton
  static final ErrorHandler _instance = ErrorHandler._internal();

  /// Factory constructor pour le singleton
  factory ErrorHandler() => _instance;

  /// Constructeur privé
  ErrorHandler._internal();

  /// Callback pour les erreurs non fatales
  void Function(SecretKeyboardException error)? onNonFatalError;

  /// Callback pour les erreurs fatales
  void Function(SecretKeyboardException error)? onFatalError;

  /// Active ou désactive le logging des erreurs
  bool enableErrorLogging = true;

  /// Traite une exception et détermine sa gravité
  void handleError(Exception error, {bool fatal = false}) {
    if (error is SecretKeyboardException) {
      _processSecretKeyboardException(error, fatal: fatal);
    } else {
      // Convertir en SecretKeyboardException pour un traitement uniforme
      final wrappedException = _wrapGenericException(error);
      _processSecretKeyboardException(wrappedException, fatal: fatal);
    }
  }

  /// Traite spécifiquement une SecretKeyboardException
  void _processSecretKeyboardException(SecretKeyboardException error, {required bool fatal}) {
    // Logging conditionnel
    if (enableErrorLogging) {
      _logError(error, fatal: fatal);
    }

    // Notification via callbacks
    if (fatal && onFatalError != null) {
      onFatalError!(error);
    } else if (!fatal && onNonFatalError != null) {
      onNonFatalError!(error);
    }

    // En mode debug, afficher plus d'informations
    if (kDebugMode) {
      _debugPrintError(error);
    }
  }

  /// Encapsule une exception générique
  SecretKeyboardException _wrapGenericException(Exception error) {
    return ConfigurationException(
      message: 'Erreur inattendue: ${error.toString()}',
      configurationType: 'GENERIC',
      details: {
        'originalError': error.toString(),
        'stackTrace': StackTrace.current.toString(),
      },
    );
  }

  /// Log l'erreur selon sa gravité
  void _logError(SecretKeyboardException error, {required bool fatal}) {
    final severity = fatal ? 'FATAL' : 'NON_FATAL';
    final timestamp = DateTime.now().toIso8601String();

    debugPrint('''
    [$timestamp] $severity ERROR
    Code: ${error.errorCode}
    Message: ${error.message}
    Details: ${error.details}
    ''');
  }

  /// Affichage détaillé en mode debug
  void _debugPrintError(SecretKeyboardException error) {
    debugPrint('=== FLUTTER SECRET KEYBOARD ERROR ===');
    debugPrint('Type: ${error.runtimeType}');
    debugPrint('Error Code: ${error.errorCode}');
    debugPrint('Message: ${error.message}');
    if (error.details != null) {
      debugPrint('Details:');
      error.details!.forEach((key, value) {
        debugPrint('  $key: $value');
      });
    }
    debugPrint('Stack Trace:');
    debugPrint(StackTrace.current.toString());
    debugPrint('=====================================');
  }

  /// Méthode utilitaire pour wrapper un appel potentiellement dangereux
  T safeExecute<T>({
    required T Function() action,
    required T defaultValue,
    String? errorContext,
  }) {
    try {
      return action();
    } catch (e) {
      final error = ConfigurationException(
        message: errorContext ?? 'Erreur lors de l\'exécution de l\'action',
        configurationType: 'EXECUTION',
        details: {
          'error': e.toString(),
          'defaultValue': defaultValue,
        },
      );
      handleError(error);
      return defaultValue;
    }
  }

  /// Méthode pour valider un paramètre avec gestion d'erreur intégrée
  void validateParameter({
    required String parameterName,
    required dynamic value,
    required bool Function(dynamic) validator,
    required String expectedDescription,
  }) {
    if (!validator(value)) {
      throw InvalidParameterException(
        parameterName: parameterName,
        value: value,
        expectedValue: expectedDescription,
      );
    }
  }
}

/// Extension pour faciliter l'utilisation du gestionnaire d'erreurs
extension ErrorHandlerExtension on Object {
  /// Obtient l'instance du gestionnaire d'erreurs
  ErrorHandler get errorHandler => ErrorHandler();
}