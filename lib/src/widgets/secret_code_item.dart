import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

/// Widget représentant un indicateur individuel du code secret
class SecretCodeItem extends StatelessWidget {
  /// Données du code secret pour cet indicateur
  final SecretCodeData secretCodeData;

  /// Taille de l'indicateur
  final double secretCodeSize;

  /// Rembourrage de la bordure
  final double secretCodeBorderPadding;

  /// Couleur active (quand le chiffre est entré)
  final Color activeColor;

  /// Couleur inactive (case vide)
  final Color inactiveColor;

  /// Couleur de fond
  final Color backgroundColor;

  /// Constructeur avec paramètres personnalisables
  const SecretCodeItem({
    super.key,
    required this.secretCodeData,
    this.secretCodeSize = DefaultValues.indicatorSize,
    this.secretCodeBorderPadding = DefaultValues.borderWidth,
    this.activeColor = DefaultValues.indicatorActiveColor,
    this.inactiveColor = DefaultValues.indicatorInactiveColor,
    this.backgroundColor = DefaultValues.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: secretCodeSize,
            height: secretCodeSize,
            padding: EdgeInsets.all(secretCodeBorderPadding),
            decoration: BoxDecoration(
              color: secretCodeData.isActive ? activeColor : inactiveColor,
              shape: BoxShape.circle,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: secretCodeData.isActive ? activeColor : backgroundColor,
                shape: BoxShape.circle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
