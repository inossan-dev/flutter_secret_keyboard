import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

/// Classe de liaison entre le clavier secret et un TextField
class SecretKeyboardTextFieldBinding {
  /// Contrôleur du clavier secret
  final SecretKeyboardController keyboardController;

  /// Contrôleur du TextField
  final TextEditingController textEditingController;

  /// Masquer le texte (comme pour un mot de passe)
  final bool obscureText;

  /// Caractère pour masquer le texte
  final String obscuringCharacter;

  /// Liste de formateurs d'entrée pour le TextField
  final List<TextInputFormatter>? inputFormatters;

  /// Dernière valeur formatée stockée
  String _lastFormattedValue = '';

  /// Constructeur avec paramètres requis
  SecretKeyboardTextFieldBinding({
    required this.keyboardController,
    required this.textEditingController,
    this.obscureText = true,
    this.obscuringCharacter = '•',
    this.inputFormatters,
  }) {
    // S'abonner aux changements de code secret
    keyboardController.addListener(_onSecretCodeChanged);

    // Initialiser la valeur si nécessaire
    if (textEditingController.text.isNotEmpty) {
      _lastFormattedValue = textEditingController.text;
    }
  }

  /// Gérer les changements de code secret
  void _onSecretCodeChanged() {
    String newValue = keyboardController.secretCode;

    // Application des formatters si disponibles
    if (inputFormatters != null && inputFormatters!.isNotEmpty) {
      TextEditingValue oldValue = TextEditingValue(
        text: _lastFormattedValue,
        selection: TextSelection.collapsed(offset: _lastFormattedValue.length),
      );

      TextEditingValue valueToFormat = TextEditingValue(
        text: newValue,
        selection: TextSelection.collapsed(offset: newValue.length),
      );

      // Application séquentielle des formatters
      TextEditingValue formattedValue = valueToFormat;
      for (var formatter in inputFormatters!) {
        formattedValue = formatter.formatEditUpdate(oldValue, formattedValue);
      }

      _lastFormattedValue = formattedValue.text;
      textEditingController.value = formattedValue;
    } else {
      _lastFormattedValue = newValue;
      textEditingController.text = newValue;
      textEditingController.selection = TextSelection.collapsed(offset: newValue.length);
    }

    // Synchronisation inverse si nécessaire
    if (keyboardController.secretCode != _lastFormattedValue) {
      keyboardController.setSecretCode(_lastFormattedValue);
    }
  }

  /// Libérer les ressources
  void dispose() {
    keyboardController.removeListener(_onSecretCodeChanged);
  }
}
