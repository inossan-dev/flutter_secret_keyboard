import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';
import 'package:flutter_secret_keyboard/src/widgets/secret_code_item.dart';

/// Widget qui affiche les indicateurs du code secret (les points)
class SecretCodeIndicator extends StatelessWidget {
  /// Contrôleur du clavier secret
  final SecretKeyboardController controller;

  /// Espacement horizontal (padding)
  final double horizontalPadding;

  /// Taille des indicateurs
  final double indicatorSize;

  /// Rembourrage de la bordure
  final double borderPadding;

  /// Couleur active
  final Color activeColor;

  /// Couleur inactive
  final Color inactiveColor;

  /// Couleur de fond
  final Color backgroundColor;

  /// Constructeur avec paramètres personnalisables
  const SecretCodeIndicator({
    super.key,
    required this.controller,
    this.horizontalPadding = DefaultValues.horizontalPadding,
    this.indicatorSize = DefaultValues.indicatorSize,
    this.borderPadding = DefaultValues.borderPadding,
    this.activeColor = DefaultValues.indicatorActiveColor,
    this.inactiveColor = DefaultValues.indicatorInactiveColor,
    this.backgroundColor = DefaultValues.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final secretCodeDatas = controller.secretCodeDatas;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Align(
            alignment: Alignment.center,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                crossAxisCount: secretCodeDatas.length,
              ),
              itemCount: secretCodeDatas.length,
              itemBuilder: (context, index) {
                var scd = secretCodeDatas[index];
                return SecretCodeItem(
                  secretCodeData: scd,
                  secretCodeSize: indicatorSize,
                  secretCodeBorderPadding: borderPadding,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  backgroundColor: backgroundColor,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
