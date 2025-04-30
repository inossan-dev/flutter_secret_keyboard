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
  }

  /// Gérer les changements de code secret
  void _onSecretCodeChanged() {
    String newValue = keyboardController.secretCode;

    // Appliquer les formatters si fournis
    if (inputFormatters != null && inputFormatters!.isNotEmpty) {
      TextEditingValue oldValue = TextEditingValue(
        text: textEditingController.text,
        selection: textEditingController.selection,
      );

      TextEditingValue formattedValue = TextEditingValue(
        text: newValue,
        selection: TextSelection.collapsed(offset: newValue.length),
      );

      // Appliquer chaque formatter séquentiellement
      for (var formatter in inputFormatters!) {
        formattedValue = formatter.formatEditUpdate(oldValue, formattedValue);
      }

      // Mettre à jour le texte avec la valeur formatée
      textEditingController.value = formattedValue;
    } else {
      // Mettre à jour normalement sans formatage
      textEditingController.text = newValue;
      textEditingController.selection = TextSelection.collapsed(offset: newValue.length);
    }
  }

  /// Libérer les ressources
  void dispose() {
    keyboardController.removeListener(_onSecretCodeChanged);
  }
}
