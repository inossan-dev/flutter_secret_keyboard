import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';
import 'package:flutter_secret_keyboard/src/widgets/animations/blur_effect.dart';
import 'package:flutter_secret_keyboard/src/widgets/animations/border_animation_effect.dart';
import 'package:flutter_secret_keyboard/src/widgets/animations/color_change_effect.dart';
import 'package:flutter_secret_keyboard/src/widgets/animations/elevation_effect.dart';
import 'package:flutter_secret_keyboard/src/widgets/animations/scale_button_effect.dart';

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

  /// Nombre de colonnes dans la grille du clavier (3 ou 4)
  final int gridColumns;

  /// Type d'effet tactile pour les touches
  final KeyTouchEffect touchEffect;

  /// Couleur de l'effet tactile (pour les effets qui utilisent une couleur)
  final Color? touchEffectColor;

  /// Durée de l'animation de l'effet tactile
  final Duration touchEffectDuration;

  /// Echelle de l'animation de l'effet tactile
  final double touchEffectScaleValue;

  /// Thème prédéfini (remplace les paramètres individuels si spécifié)
  final SecretKeyboardTheme? theme;

  /// Afficher une bordure externe lorsque showGrid est true et qu'aucun thème n'est défini
  final bool showOuterBorder;

  /// Intensité maximale de l'effet de flou
  final double blurIntensity;

  /// Durée de l'effet de flou
  final Duration blurDuration;

  /// Activer/désactiver l'effet de flou
  final bool blurEnabled;

  /// Constructeur avec paramètres personnalisables
  SecretKeyboard({
    super.key,
    required this.controller,
    required this.onClick,
    this.showSecretCode = true,
    this.showGrid = true,
    this.showOuterBorder = false,
    this.cellAspectRatio = 1,
    this.onCodeCompleted,
    this.onFingerprintClick,
    this.onCanCleanMessage,
    this.height,
    this.width,
    backgroundColor,
    cellStyle,
    this.codeLength = 4,
    this.deleteButtonWidget,
    this.fingerprintButtonWidget,
    indicatorActiveColor = Colors.orange,
    indicatorInactiveColor = Colors.black,
    this.indicatorBackgroundColor = Colors.white,
    this.textController,
    this.obscureText = true,
    this.obscuringCharacter = '•',
    this.inputFormatters,
    this.gridColumns = 4,
    this.theme,
    touchEffect = KeyTouchEffect.none,
    touchEffectColor,
    this.touchEffectScaleValue = 0.95,
    touchEffectDuration = const Duration(milliseconds: 150),
    blurIntensity = BlurEffectConstants.DEFAULT_BLUR_INTENSITY,
    blurDuration = BlurEffectConstants.DEFAULT_BLUR_DURATION,
    blurEnabled = true,
  })  : touchEffect = theme?.touchEffect ?? touchEffect,
        touchEffectColor = theme?.primaryColor ?? touchEffectColor,
        touchEffectDuration = theme?.animationDuration ?? touchEffectDuration,
        backgroundColor = theme?.backgroundColor ?? backgroundColor,
        indicatorActiveColor = theme?.primaryColor ?? indicatorActiveColor,
        indicatorInactiveColor =
            theme?.secondaryColor ?? indicatorInactiveColor ?? Colors.black,
        cellStyle = theme?.textStyle ?? cellStyle,
        blurIntensity = theme?.blurIntensity ?? blurIntensity,
        blurDuration = theme?.blurDuration ?? blurDuration,
        blurEnabled = theme?.blurEnabled ?? blurEnabled,
        assert(gridColumns == 3 || gridColumns == 4,
            'Le nombre de colonnes doit être 3 ou 4');

  @override
  State<SecretKeyboard> createState() => _SecretKeyboardState();
}

class _SecretKeyboardState extends State<SecretKeyboard> {
  bool _isCompleted = false;
  late int _gridViewCrossAxisCount;
  SecretKeyboardTextFieldBinding? _textFieldBinding;

  @override
  void initState() {
    super.initState();
    _isCompleted = false;
    _gridViewCrossAxisCount = widget.gridColumns;

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

    // Mettre à jour le nombre de colonnes si nécessaire
    if (widget.gridColumns != oldWidget.gridColumns) {
      _gridViewCrossAxisCount = widget.gridColumns;
    }

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
        _isCompleted =
            false; // Réinitialiser l'état complété lors d'une suppression
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
    // Cas 1: Aucun thème n'est défini - afficher les bordures par défaut
    if (widget.theme == null && widget.showGrid) {
      final bool isLastRow = index >= widget.controller.secretKeyboardData.length - _gridViewCrossAxisCount;
      final bool isLastColumn = (index + 1) % _gridViewCrossAxisCount == 0;

      return BoxDecoration(
        color: widget.backgroundColor,
        border: Border(
          right: isLastColumn ? BorderSide.none : BorderSide(
            color: Colors.grey.withValues(alpha: 0.5),
            width: 1.0,
            style: BorderStyle.solid,
          ),
          bottom: isLastRow ? BorderSide.none : BorderSide(
            color: Colors.grey.withValues(alpha: 0.5),
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
      );
    }
    // Cas 2: Un thème est défini avec showBorders = true
    else if (widget.theme != null && widget.theme!.showBorders && widget.showGrid) {
      final bool isLastRow = index >= widget.controller.secretKeyboardData.length - _gridViewCrossAxisCount;
      final bool isLastColumn = (index + 1) % _gridViewCrossAxisCount == 0;
      final borderColor = widget.theme!.borderColor ?? widget.theme!.primaryColor.withValues(alpha: 0.3);

      return BoxDecoration(
        color: widget.backgroundColor,
        border: Border(
          right: isLastColumn ? BorderSide.none : BorderSide(
            color: borderColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          bottom: isLastRow ? BorderSide.none : BorderSide(
            color: borderColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
      );
    }
    // Cas 3: Un thème est défini avec showBorders = false (ou showGrid = false)
    else {
      return BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      );
    }
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
                SecretCodeIndicator(
                  controller: widget.controller,
                  activeColor: widget.indicatorActiveColor,
                  inactiveColor: widget.indicatorInactiveColor,
                  backgroundColor: widget.indicatorBackgroundColor,
                ),

              // Séparateur
              if (widget.showSecretCode) const SizedBox(height: 10),

              // Clavier
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration:
                  // Cas 1: Thème défini avec bordure externe activée
                  (widget.theme?.showBorders == true && widget.theme?.showOuterBorder == true)
                      // Cas 2: Pas de thème, mais showGrid et showOuterBorder sont tous deux true
                      || (widget.theme == null && widget.showGrid && widget.showOuterBorder)
                      ? BoxDecoration(
                    border: Border.all(
                      color: widget.theme?.borderColor ?? Colors.grey.withValues(alpha: 0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  )
                      : null,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: (widget.theme == null || widget.theme!.showBorders) ? 0 : 8,
                      mainAxisSpacing: (widget.theme == null || widget.theme!.showBorders) ? 0 : 8,
                      crossAxisCount: _gridViewCrossAxisCount,
                      childAspectRatio: widget.cellAspectRatio,
                    ),
                    itemCount: widget.controller.secretKeyboardData.length,
                    itemBuilder: (context, index) {
                      var skd = widget.controller.secretKeyboardData[index];

                      // Base container that will be wrapped with the effect
                      final keyContainer = Container(
                        color: widget.showGrid ? null : Colors.transparent,
                        decoration: widget.showGrid ? _createBoxDecoration(index) : null,
                        child: SecretKeyboardItem(
                          secretKeyboardData: skd,
                          cellStyle: widget.cellStyle,
                          backgroundColor:
                              widget.touchEffect != KeyTouchEffect.none &&
                                      widget.touchEffect != KeyTouchEffect.ripple
                                  ? Colors.transparent
                                  : widget.backgroundColor,
                          deleteButtonWidget: widget.deleteButtonWidget,
                          fingerprintButtonWidget: widget.fingerprintButtonWidget,
                        ),
                      );

                      // Function to call when key is tapped
                      onTap() {
                        String keyValue =
                            widget.controller.secretKeyboardData[index].key;
                        handleKeyPress(keyValue);
                      }

                      // Apply the selected effect
                      switch (widget.touchEffect) {
                        case KeyTouchEffect.none:
                          return GestureDetector(
                            onTap: onTap,
                            child: keyContainer,
                          );

                        case KeyTouchEffect.ripple:
                          return InkWell(
                            onTap: onTap,
                            splashColor:
                                widget.touchEffectColor?.withValues(alpha: 0.3) ??
                                    widget.indicatorActiveColor
                                        .withValues(alpha: 0.3),
                            highlightColor:
                                widget.touchEffectColor?.withValues(alpha: 0.1) ??
                                    widget.indicatorActiveColor
                                        .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            child: keyContainer,
                          );

                        case KeyTouchEffect.scale:
                          return ScaleButtonEffect(
                            onTap: onTap,
                            duration: widget.touchEffectDuration,
                            scaleValue: widget.touchEffectScaleValue,
                            child: keyContainer,
                          );

                        case KeyTouchEffect.color:
                          return ColorChangeEffect(
                            onTap: onTap,
                            normalColor: widget.backgroundColor,
                            pressedColor:
                                widget.touchEffectColor?.withValues(alpha: 0.3) ??
                                    Colors.grey.shade300,
                            duration: widget.touchEffectDuration,
                            child: keyContainer,
                          );

                        case KeyTouchEffect.elevation:
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ElevationEffect(
                              onTap: onTap,
                              backgroundColor:
                                  widget.backgroundColor ?? Colors.white,
                              duration: widget.touchEffectDuration,
                              child: keyContainer,
                            ),
                          );

                        case KeyTouchEffect.border:
                          return BorderAnimationEffect(
                            onTap: onTap,
                            backgroundColor: widget.backgroundColor,
                            borderColor: widget.touchEffectColor ??
                                widget.indicatorActiveColor,
                            duration: widget.touchEffectDuration,
                            child: keyContainer,
                          );

                        case KeyTouchEffect.blur:
                          return BlurKeyEffect(
                            onTap: onTap,
                            maxBlurIntensity: widget.blurIntensity,
                            blurDuration: widget.blurDuration,
                            enabled: widget.blurEnabled,
                            child: keyContainer,
                          );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
