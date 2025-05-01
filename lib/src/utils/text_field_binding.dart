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

    // Appliquer les formatters si fournis
    if (inputFormatters != null && inputFormatters!.isNotEmpty) {
      // Créer la valeur de départ
      TextEditingValue oldValue = TextEditingValue(
        text: _lastFormattedValue,
        selection: TextSelection.collapsed(offset: _lastFormattedValue.length),
      );

      // Créer la nouvelle valeur à formater
      TextEditingValue valueToFormat = TextEditingValue(
        text: newValue,
        selection: TextSelection.collapsed(offset: newValue.length),
      );

      // Vérifier si la touche de suppression a été utilisée
      bool isDelete = newValue.length < _lastFormattedValue.length;

      // Pour la suppression, utiliser une approche différente
      if (isDelete && newValue.isNotEmpty) {
        // Pour la suppression, on recalcule depuis le début pour s'assurer
        // que les formatters sont appliqués correctement
        valueToFormat = TextEditingValue(
          text: newValue,
          selection: TextSelection.collapsed(offset: newValue.length),
        );
      }

      // Appliquer chaque formatter séquentiellement
      TextEditingValue formattedValue = valueToFormat;
      for (var formatter in inputFormatters!) {
        // Si c'est un FilteringTextInputFormatter.deny pour le 0 initial,
        // on vérifie explicitement si le premier caractère est '0'
        if (formatter is FilteringTextInputFormatter &&
            formatter.filterPattern.toString() == r'^0' &&
            formattedValue.text.startsWith('0') &&
            formattedValue.text.length == 1) {
          // On ignore le caractère '0' au début
          formattedValue = const TextEditingValue(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        } else {
          formattedValue = formatter.formatEditUpdate(oldValue, formattedValue);
        }
      }

      // Sauvegarder la dernière valeur formatée
      _lastFormattedValue = formattedValue.text;

      // Mettre à jour le texte avec la valeur formatée
      textEditingController.value = formattedValue;
    } else {
      // Mise à jour normale sans formatage
      _lastFormattedValue = newValue;
      textEditingController.text = newValue;
      textEditingController.selection = TextSelection.collapsed(offset: newValue.length);
    }

    // Mettre à jour le code secret dans le controller si nécessaire
    if (keyboardController.secretCode != _lastFormattedValue) {
      keyboardController.setSecretCode(_lastFormattedValue);
    }
  }

  /// Libérer les ressources
  void dispose() {
    keyboardController.removeListener(_onSecretCodeChanged);
  }
}
