import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

/// Builder responsable de la création et de la gestion des instances de liaison TextField
class TextFieldBindingBuilder {
  /// Crée une instance de SecretKeyboardTextFieldBinding si nécessaire
  static SecretKeyboardTextFieldBinding? build({
    required SecretKeyboardController keyboardController,
    TextEditingController? textController,
    required bool obscureText,
    required String obscuringCharacter,
    List<TextInputFormatter>? inputFormatters,
  }) {
    if (textController == null) return null;

    return SecretKeyboardTextFieldBinding(
      keyboardController: keyboardController,
      textEditingController: textController,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      inputFormatters: inputFormatters,
    );
  }

  /// Détermine si les paramètres de liaison ont changé
  static bool hasConfigurationChanged({
    TextEditingController? oldTextController,
    TextEditingController? newTextController,
    bool oldObscureText = true,
    bool newObscureText = true,
    String oldObscuringCharacter = '•',
    String newObscuringCharacter = '•',
    List<TextInputFormatter>? oldInputFormatters,
    List<TextInputFormatter>? newInputFormatters,
  }) {
    return oldTextController != newTextController ||
        oldObscureText != newObscureText ||
        oldObscuringCharacter != newObscuringCharacter ||
        _hasFormattersChanged(oldInputFormatters, newInputFormatters);
  }

  /// Vérifie si les formatters ont changé
  static bool _hasFormattersChanged(
      List<TextInputFormatter>? oldFormatters,
      List<TextInputFormatter>? newFormatters,
      ) {
    if (oldFormatters == null && newFormatters == null) return false;
    if (oldFormatters == null || newFormatters == null) return true;
    if (oldFormatters.length != newFormatters.length) return true;

    // Comparaison plus approfondie si nécessaire
    return !identical(oldFormatters, newFormatters);
  }
}