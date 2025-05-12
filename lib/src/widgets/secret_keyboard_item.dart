import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/src/models/secret_keyboard_data.dart';

/// Widget représentant une touche du clavier secret avec nomenclature améliorée
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
    switch (secretKeyboardData.type) {
      case KeyType.numeric:
        return Text(
          secretKeyboardData.key,
          style: cellStyle ?? const TextStyle(fontSize: 24, color: Colors.white),
        );

      case KeyType.fingerprint:
        return fingerprintButtonWidget ?? Icon(
          Icons.fingerprint,
          size: 30,
          color: cellStyle?.color ?? Colors.white,
        );

      case KeyType.delete:
        return deleteButtonWidget ?? Icon(
          Icons.backspace,
          size: 30,
          color: cellStyle?.color ?? Colors.white,
        );

      case KeyType.empty:
        return const SizedBox.shrink();

      case KeyType.custom:
        return Text(
          secretKeyboardData.displayLabel ?? secretKeyboardData.key,
          style: cellStyle ?? const TextStyle(fontSize: 24, color: Colors.white),
        );
    }
  }
}
