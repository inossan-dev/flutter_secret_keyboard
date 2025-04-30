import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

/// Classe utilitaire pour lier un clavier secret à un TextField
class SecretKeyboardTextFieldBinding {
  /// Contrôleur du clavier secret
  final SecretKeyboardController keyboardController;

  /// Contrôleur du champ de texte
  final TextEditingController textEditingController;

  /// Masquer le texte (comme pour un mot de passe)
  final bool obscureText;

  /// Caractère de masquage pour le texte masqué
  final String obscuringCharacter;

  /// Constructeur
  SecretKeyboardTextFieldBinding({
    required this.keyboardController,
    required this.textEditingController,
    this.obscureText = true,
    this.obscuringCharacter = '•',
  }) {
    // Écouter les changements du clavier
    keyboardController.addListener(_updateTextField);

    // Configuration initiale
    _updateTextField();
  }

  /// Mettre à jour le TextField en fonction du code saisi
  void _updateTextField() {
    final code = keyboardController.secretCode;

    if (obscureText) {
      // Si le texte est masqué, afficher des caractères de masquage
      final maskedText = obscuringCharacter * code.length;
      textEditingController.value = TextEditingValue(
        text: maskedText,
        selection: TextSelection.collapsed(offset: maskedText.length),
      );
    } else {
      // Sinon, afficher le code tel quel
      textEditingController.value = TextEditingValue(
        text: code,
        selection: TextSelection.collapsed(offset: code.length),
      );
    }
  }

  /// Synchroniser le contrôleur du clavier avec le contenu du TextField
  /// Cette méthode est utile si le texte est modifié directement dans le TextField
  /// et que nous voulons mettre à jour le clavier en conséquence
  /// (Cette fonctionnalité est avancée et pourrait nécessiter une logique supplémentaire
  /// pour garantir que seuls les chiffres sont acceptés)
  void syncFromTextField() {
    // Récupérer le texte actuel du TextField
    final textValue = textEditingController.text;

    // Filtrer pour ne conserver que les chiffres
    final digitsOnly = textValue.replaceAll(RegExp(r'[^0-9]'), '');

    // Limiter à la longueur maximale
    final maxLength = keyboardController.maxLength;
    final truncatedValue = digitsOnly.length > maxLength
        ? digitsOnly.substring(0, maxLength)
        : digitsOnly;

    // Si nécessaire, mettre à jour le TextField avec la valeur filtrée/tronquée
    if (textValue != truncatedValue) {
      textEditingController.value = TextEditingValue(
        text: obscureText ? obscuringCharacter * truncatedValue.length : truncatedValue,
        selection: TextSelection.collapsed(offset: truncatedValue.length),
      );
    }

    // Réinitialiser et mettre à jour le code secret dans le contrôleur
    keyboardController.resetSecretCode(initCode: truncatedValue);
  }

  /// Libérer les ressources
  void dispose() {
    keyboardController.removeListener(_updateTextField);
  }
}