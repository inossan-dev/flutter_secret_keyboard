
import 'package:flutter/services.dart';

/// Formatter personnalisé pour empêcher le '0' initial dans une saisie numérique
///
/// Ce formatter est spécialement conçu pour fonctionner avec SecretKeyboard
/// lorsque vous souhaitez empêcher l'utilisateur de commencer sa saisie par '0'.
/// Il est plus fiable que `FilteringTextInputFormatter.deny(RegExp(r'^0'))` dans
/// le contexte d'un clavier secret.
///
/// Exemple d'utilisation:
/// ```dart
/// SecretKeyboard(
///   controller: keyboardController,
///   textController: textController,
///   inputFormatters: [
///     PreventLeadingZeroFormatter(),
///     // Autres formatters...
///   ],
/// )
/// ```
class PreventLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Si la nouvelle valeur est un '0' seul et qu'on commence une saisie
    if (newValue.text == '0' && oldValue.text.isEmpty) {
      return oldValue; // Rejeter le '0' initial
    }

    // Si on a un '0' suivi d'autres chiffres (ex: '01'), le remplacer par les chiffres qui suivent
    if (newValue.text.startsWith('0') && newValue.text.length > 1) {
      final sanitized = newValue.text.replaceFirst(RegExp(r'^0+'), '');
      return TextEditingValue(
        text: sanitized,
        selection: TextSelection.collapsed(offset: sanitized.length),
      );
    }

    // Sinon, accepter la valeur
    return newValue;
  }
}
