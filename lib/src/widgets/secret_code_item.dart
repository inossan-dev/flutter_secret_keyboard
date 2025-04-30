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
    this.secretCodeSize = 20,
    this.secretCodeBorderPadding = 1,
    this.activeColor = Colors.orange,
    this.inactiveColor = Colors.black,
    this.backgroundColor = Colors.white,
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
              //border: Border.all(color: secretCodeData.isActive ? activeBorderColor : inactiveBorderColor),
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