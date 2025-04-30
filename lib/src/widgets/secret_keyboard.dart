import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';
import 'package:flutter_secret_keyboard/src/utils/constants.dart';

import 'secret_code_item.dart';
import 'secret_keyboard_item.dart';

/// Widget principal du clavier secret
class SecretKeyboard extends StatefulWidget {
  /// Contrôleur du clavier secret
  final SecretKeyboardController controller;

  /// Afficher les indicateurs de code secret
  final bool showSecretCode;

  /// Afficher la grille du clavier
  final bool showGrid;

  /// Rapport d'aspect des cellules
  final double cellAspectRatio;

  /// Fonction appelée à chaque clic sur une touche
  final Function(String) onClick;

  /// Fonction appelée lorsque le code est complet
  final Function(String)? onCodeCompleted;

  /// Fonction appelée lors du clic sur l'empreinte digitale
  final Function(String)? onFingerprintClick;

  /// Fonction appelée pour indiquer si le message peut être effacé
  final Function(bool)? onCanCleanMessage;

  /// Hauteur du clavier
  final double? height;

  /// Largeur du clavier
  final double? width;

  /// Couleur de fond
  final Color? backgroundColor;

  /// Style de texte des cellules
  final TextStyle? cellStyle;

  /// Longueur du code
  final int codeLength;

  /// Widget personnalisé pour le bouton de suppression
  final Widget? deleteButtonWidget;

  /// Widget personnalisé pour le bouton d'empreinte digitale
  final Widget? fingerprintButtonWidget;

  /// Couleur active pour les indicateurs
  final Color indicatorActiveColor;

  /// Couleur inactive pour les indicateurs
  final Color indicatorInactiveColor;

  /// Couleur de fond des indicateurs
  final Color indicatorBackgroundColor;

  /// Contrôleur de TextField pour la liaison avec un champ de texte
  final TextEditingController? textController;

  /// Masquer le texte dans le TextField lié (comme pour un mot de passe)
  final bool obscureText;

  /// Caractère à utiliser pour masquer le texte
  final String obscuringCharacter;

  /// Liste de formateurs d'entrée pour le TextField lié
  final List<TextInputFormatter>? inputFormatters;

  /// Constructeur avec paramètres personnalisables
  const SecretKeyboard({
    super.key,
    required this.controller,
    required this.onClick,
    this.showSecretCode = true,
    this.showGrid = true,
    this.cellAspectRatio = 1,
    this.onCodeCompleted,
    this.onFingerprintClick,
    this.onCanCleanMessage,
    this.height,
    this.width,
    this.backgroundColor,
    this.cellStyle,
    this.codeLength = 4,
    this.deleteButtonWidget,
    this.fingerprintButtonWidget,
    this.indicatorActiveColor = Colors.orange,
    this.indicatorInactiveColor = Colors.black,
    this.indicatorBackgroundColor = Colors.white,
    this.textController,
    this.obscureText = true,
    this.obscuringCharacter = '•',
    this.inputFormatters,
  });

  @override
  State<SecretKeyboard> createState() => _SecretKeyboardState();
}

class _SecretKeyboardState extends State<SecretKeyboard> {
  bool _isCompleted = false;
  final int _gridViewCrossAxisCount = 4;
  SecretKeyboardTextFieldBinding? _textFieldBinding;

  @override
  void initState() {
    super.initState();
    _isCompleted = false;

    // Si un contrôleur de texte est fourni, configurer la liaison
    if (widget.textController != null) {
      _textFieldBinding = SecretKeyboardTextFieldBinding(
        keyboardController: widget.controller,
        textEditingController: widget.textController!,
        obscureText: widget.obscureText,
        obscuringCharacter: widget.obscuringCharacter,
        inputFormatters: widget.inputFormatters,
      );
    }
  }

  @override
  void didUpdateWidget(SecretKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isCompleted = false;

    // Gérer les changements de contrôleur de texte
    if (widget.textController != oldWidget.textController ||
        widget.obscureText != oldWidget.obscureText ||
        widget.obscuringCharacter != oldWidget.obscuringCharacter ||
        widget.inputFormatters != oldWidget.inputFormatters) {
      // Disposer de l'ancienne liaison
      _textFieldBinding?.dispose();

      // Créer une nouvelle liaison si nécessaire
      if (widget.textController != null) {
        _textFieldBinding = SecretKeyboardTextFieldBinding(
          keyboardController: widget.controller,
          textEditingController: widget.textController!,
          obscureText: widget.obscureText,
          obscuringCharacter: widget.obscuringCharacter,
          inputFormatters: widget.inputFormatters,
        );
      } else {
        _textFieldBinding = null;
      }
    }
  }

  @override
  void dispose() {
    _textFieldBinding?.dispose();
    super.dispose();
  }

  /// Réinitialiser le clavier
  void resetKeyboard() {
    if (mounted) {
      setState(() {
        _isCompleted = false;
      });
      widget.controller.resetSecretCode();
    }
  }

  /// Gérer l'appui sur une touche
  void handleKeyPress(String keyValue) {
    if (_isCompleted && keyValue != SecretKeyboardConstants.DELETE_KEY) {
      return; // Autoriser la suppression même après complétion
    }

    // Obtenir le nouveau code après l'appui sur la touche
    String newCode = widget.controller.formSecretCode(keyValue);

    setState(() {
      // Notification des callbacks externes
      widget.onClick(newCode);

      if (!_isCompleted &&
          widget.onCodeCompleted != null &&
          newCode.isNotEmpty &&
          newCode.length == widget.codeLength) {
        _isCompleted = true;
        widget.onCodeCompleted!(newCode);
      } else if (keyValue == SecretKeyboardConstants.DELETE_KEY) {
        _isCompleted = false; // Réinitialiser l'état complété lors d'une suppression
      }

      if (widget.onFingerprintClick != null &&
          keyValue == SecretKeyboardConstants.FINGERPRINT_KEY) {
        widget.onFingerprintClick!(newCode);
      }

      if (widget.onCanCleanMessage != null && newCode.length == 1) {
        widget.onCanCleanMessage!(true);
      }
    });
  }

  /// Créer une décoration de bordure pour la grille
  BoxDecoration _createBoxDecoration(int index) {
    index++;
    return BoxDecoration(
      border: Border(
        left: BorderSide(
          color: ((index >= 2 && index <= 4) ||
              (index >= 6 && index <= 8) ||
              (index >= 10 && index <= 12))
              ? Colors.black
              : Colors.transparent,
          width: 0.8,
        ),
        top: BorderSide(
          color: index > _gridViewCrossAxisCount ? Colors.black : Colors.transparent,
          width: 0.8,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: Column(
              children: [
                // Afficher les indicateurs du code secret
                if (widget.showSecretCode)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 4.5,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: (widget.controller.secretCodeDatas.isNotEmpty)
                          ? GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          crossAxisCount: widget.controller.secretCodeDatas.length,
                        ),
                        itemCount: widget.controller.secretCodeDatas.length,
                        itemBuilder: (context, index) {
                          var scd = widget.controller.secretCodeDatas[index];
                          return SecretCodeItem(
                            secretCodeData: scd,
                            activeColor: widget.indicatorActiveColor,
                            inactiveColor: widget.indicatorInactiveColor,
                            backgroundColor: widget.indicatorBackgroundColor,
                          );
                        },
                      )
                          : Container(),
                    ),
                  ),

                // Séparateur
                if (widget.showSecretCode)
                  const SizedBox(height: 10),

                // Clavier
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      crossAxisCount: _gridViewCrossAxisCount,
                      childAspectRatio: widget.cellAspectRatio,
                    ),
                    itemCount: widget.controller.secretKeyboardData.length,
                    itemBuilder: (context, index) {
                      var skd = widget.controller.secretKeyboardData[index];
                      return InkWell(
                        onTap: () {
                          String keyValue = widget.controller.secretKeyboardData[index].key;
                          handleKeyPress(keyValue);
                        },
                        child: Container(
                          color: widget.showGrid ? null : Colors.transparent,
                          decoration: widget.showGrid
                              ? _createBoxDecoration(index)
                              : null,
                          child: SecretKeyboardItem(
                            secretKeyboardData: skd,
                            cellStyle: widget.cellStyle,
                            backgroundColor: widget.backgroundColor,
                            deleteButtonWidget: widget.deleteButtonWidget,
                            fingerprintButtonWidget: widget.fingerprintButtonWidget,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
