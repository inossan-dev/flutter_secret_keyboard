import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

/// Widget représentant une touche du clavier secret
class SecretKeyboardItem extends StatelessWidget {
  /// Données de la touche
  final SecretKeyboardData secretKeyboardData;

  /// Style du texte pour les touches numériques
  final TextStyle? cellStyle;

  /// Couleur de fond de la touche
  final Color? backgroundColor;

  /// Widget personnalisé pour le bouton de suppression
  final Widget? deleteButtonWidget;

  /// Widget personnalisé pour le bouton d'empreinte digitale
  final Widget? fingerprintButtonWidget;

  /// Constructeur avec paramètres personnalisables
  const SecretKeyboardItem({
    super.key,
    required this.secretKeyboardData,
    this.cellStyle,
    this.backgroundColor,
    this.deleteButtonWidget,
    this.fingerprintButtonWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildKeyContent(),
        ],
      ),
    );
  }

  /// Construire le contenu de la touche selon son type
  Widget _buildKeyContent() {
    // Touche numérique
    if (secretKeyboardData.key != SecretKeyboardConstants.DELETE_KEY &&
        secretKeyboardData.key != SecretKeyboardConstants.FINGERPRINT_KEY) {
      return Text(
        secretKeyboardData.key,
        style: cellStyle ?? const TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      );
    }
    // Touche d'empreinte digitale
    else if (secretKeyboardData.key == SecretKeyboardConstants.FINGERPRINT_KEY) {
      return fingerprintButtonWidget ?? Icon(
        Icons.fingerprint,
        size: 30,
        color: cellStyle?.color ?? Colors.black,
      );
    }
    // Touche de suppression
    else if (secretKeyboardData.key == SecretKeyboardConstants.DELETE_KEY) {
      return deleteButtonWidget ?? Icon(
        Icons.backspace,
        size: 30,
        color: cellStyle?.color ?? Colors.black,
      );
    }
    // Espace vide
    else {
      return SizedBox.shrink();
    }
  }
}