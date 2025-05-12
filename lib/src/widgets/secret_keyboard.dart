import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';
import 'package:flutter_secret_keyboard/src/constants/secret_keyboard_constants.dart';
import 'package:flutter_secret_keyboard/src/utils/validation_utils.dart';
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

  /// Longueur du code
  final int codeLength;

  /// Widget personnalisé pour le bouton de suppression
  final Widget? deleteButtonWidget;

  /// Widget personnalisé pour le bouton d'empreinte digitale
  final Widget? fingerprintButtonWidget;

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

  final KeyTouchEffect? touchEffect;
  final bool? showBorders;

  // Niveau 1 : Thème simplifié
  final SecretKeyboardTheme? theme;

  // Niveau 2 : Style complet
  final SecretKeyboardStyle? style;

  // Niveau 3 : Personnalisations directes (déprécié mais maintenu pour compatibilité)
  @Deprecated('Utilisez le paramètre style à la place')
  final Color? backgroundColor;
  @Deprecated('Utilisez le paramètre style à la place')
  final TextStyle? cellTextStyle;

  SecretKeyboard({
    super.key,
    required this.controller,
    required this.onClick,
    this.showSecretCode = true,
    this.showGrid = true,
    this.onCodeCompleted,
    this.onFingerprintClick,
    this.onCanCleanMessage,
    this.height,
    this.width,
    int codeLength = 4,
    this.deleteButtonWidget,
    this.fingerprintButtonWidget,
    this.textController,
    this.obscureText = true,
    this.obscuringCharacter = '•',
    this.inputFormatters,
    int gridColumns = 4,
    this.style,
    this.theme,
    this.backgroundColor,
    this.cellTextStyle,
    this.touchEffect,
    this.showBorders,
  }) : gridColumns = ValidationUtils.validateGridColumns(gridColumns),
        codeLength = ValidationUtils.validateMaxLength(codeLength);

  /// Obtient le style final avec une hiérarchie claire
  /// Priorité : Personnalisations directes > Style > Thème > Défaut
  SecretKeyboardStyle get finalStyle {
    // 1. Commencer avec le style par défaut
    SecretKeyboardStyle resultStyle = const SecretKeyboardStyle();

    // 2. Appliquer le thème s'il est fourni
    if (theme != null) {
      resultStyle = resultStyle.merge(theme?.toStyle());
    }

    // 3. Appliquer le style s'il est fourni
    if (style != null) {
      resultStyle = resultStyle.merge(style);
    }

    // 4. Appliquer les personnalisations directes (pour compatibilité)
    if (backgroundColor != null || cellTextStyle != null) {
      resultStyle = resultStyle.copyWith(
        backgroundColor: backgroundColor,
        cellTextStyle: cellTextStyle,
      );
    }

    return resultStyle;
  }

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

    if (widget.gridColumns != oldWidget.gridColumns) {
      _gridViewCrossAxisCount = widget.gridColumns;
    }

    if (widget.textController != oldWidget.textController ||
        widget.obscureText != oldWidget.obscureText ||
        widget.obscuringCharacter != oldWidget.obscuringCharacter ||
        widget.inputFormatters != oldWidget.inputFormatters) {
      _textFieldBinding?.dispose();

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

  void resetKeyboard() {
    if (mounted) {
      setState(() {
        _isCompleted = false;
      });
      widget.controller.resetSecretCode();
    }
  }

  void handleKeyPress(String keyValue) {
    final normalizedKey = SecretKeyboardConstants.convertLegacyKey(keyValue);

    if (_isCompleted && normalizedKey != SecretKeyboardConstants.DELETE_KEY) {
      return;
    }

    String newCode = widget.controller.formSecretCode(keyValue);

    setState(() {
      widget.onClick(newCode);

      if (!_isCompleted &&
          widget.onCodeCompleted != null &&
          newCode.isNotEmpty &&
          newCode.length == widget.codeLength) {
        _isCompleted = true;
        widget.onCodeCompleted!(newCode);
      } else if (normalizedKey == SecretKeyboardConstants.DELETE_KEY) {
        _isCompleted = false;
      }

      if (widget.onFingerprintClick != null &&
          normalizedKey == SecretKeyboardConstants.FINGERPRINT_KEY) {
        widget.onFingerprintClick!(newCode);
      }

      if (widget.onCanCleanMessage != null && newCode.length == 1) {
        widget.onCanCleanMessage!(true);
      }
    });
  }

  BoxDecoration _createBoxDecoration(int index) {
    final style = widget.finalStyle;

    if (!widget.showGrid) {
      return BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      );
    }

    if (!style.showBorders) {
      return BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      );
    }

    final borderColor = style.borderColor ??
        style.indicatorActiveColor.withValues(alpha: 0.3);

    final bool isLastRow = index >= widget.controller.secretKeyboardData.length - _gridViewCrossAxisCount;
    final bool isLastColumn = (index + 1) % _gridViewCrossAxisCount == 0;

    return BoxDecoration(
      color: style.backgroundColor,
      border: Border(
        right: isLastColumn ? BorderSide.none : BorderSide(
          color: borderColor,
          width: style.borderWidth,
        ),
        bottom: isLastRow ? BorderSide.none : BorderSide(
          color: borderColor,
          width: style.borderWidth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.finalStyle;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return SizedBox(
          height: widget.height,
          width: widget.width,
          child: Column(
            children: [
              if (widget.showSecretCode)
                SecretCodeIndicator(
                  controller: widget.controller,
                  activeColor: style.indicatorActiveColor,
                  inactiveColor: style.indicatorInactiveColor,
                  backgroundColor: style.indicatorBackgroundColor,
                  horizontalPadding: style.horizontalPadding,
                  indicatorSize: style.indicatorSize,
                  borderPadding: style.borderPadding,
                ),

              if (widget.showSecretCode) const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: (style.showBorders && style.showOuterBorder) ||
                      (widget.theme == null && widget.showGrid && style.showOuterBorder)
                      ? BoxDecoration(
                    border: Border.all(
                      color: style.borderColor ?? Colors.grey.withValues(alpha: 0.5),
                      width: style.borderWidth,
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
                      crossAxisSpacing: style.showBorders ? 0 : 8,
                      mainAxisSpacing: style.showBorders ? 0 : 8,
                      crossAxisCount: _gridViewCrossAxisCount,
                      childAspectRatio: style.cellAspectRatio,
                    ),
                    itemCount: widget.controller.secretKeyboardData.length,
                    itemBuilder: (context, index) {
                      var skd = widget.controller.secretKeyboardData[index];

                      final keyContainer = Container(
                        color: widget.showGrid ? null : Colors.transparent,
                        decoration: widget.showGrid ? _createBoxDecoration(index) : null,
                        child: SecretKeyboardItem(
                          secretKeyboardData: skd,
                          cellStyle: style.cellTextStyle,
                          backgroundColor: style.touchEffect != KeyTouchEffect.none &&
                              style.touchEffect != KeyTouchEffect.ripple
                              ? Colors.transparent
                              : style.backgroundColor,
                          deleteButtonWidget: widget.deleteButtonWidget,
                          fingerprintButtonWidget: widget.fingerprintButtonWidget,
                        ),
                      );

                      onTap() {
                        String keyValue = widget.controller.secretKeyboardData[index].key;
                        handleKeyPress(keyValue);
                      }

                      switch (style.touchEffect) {
                        case KeyTouchEffect.none:
                          return GestureDetector(
                            onTap: onTap,
                            child: keyContainer,
                          );

                        case KeyTouchEffect.ripple:
                          return InkWell(
                            onTap: onTap,
                            splashColor: style.touchEffectColor?.withValues(alpha: 0.3) ??
                                style.indicatorActiveColor.withValues(alpha: 0.3),
                            highlightColor: style.touchEffectColor?.withValues(alpha: 0.1) ??
                                style.indicatorActiveColor.withValues(alpha: 0.1),
                            borderRadius: style.borderRadius,
                            child: keyContainer,
                          );

                        case KeyTouchEffect.scale:
                          return ScaleButtonEffect(
                            onTap: onTap,
                            duration: style.touchEffectDuration,
                            scaleValue: style.touchEffectScaleValue,
                            child: keyContainer,
                          );

                        case KeyTouchEffect.color:
                          return ColorChangeEffect(
                            onTap: onTap,
                            normalColor: style.backgroundColor,
                            pressedColor: style.touchEffectColor?.withValues(alpha: 0.3) ??
                                Colors.grey.shade300,
                            duration: style.touchEffectDuration,
                            borderRadius: style.borderRadius,
                            child: keyContainer,
                          );

                        case KeyTouchEffect.elevation:
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ElevationEffect(
                              onTap: onTap,
                              backgroundColor: style.backgroundColor,
                              duration: style.touchEffectDuration,
                              borderRadius: style.borderRadius,
                              child: keyContainer,
                            ),
                          );

                        case KeyTouchEffect.border:
                          return BorderAnimationEffect(
                            onTap: onTap,
                            backgroundColor: style.backgroundColor,
                            borderColor: style.touchEffectColor ?? style.indicatorActiveColor,
                            duration: style.touchEffectDuration,
                            borderRadius: style.borderRadius,
                            child: keyContainer,
                          );

                        case KeyTouchEffect.blur:
                          return BlurKeyEffect(
                            onTap: onTap,
                            maxBlurIntensity: style.blurIntensity,
                            blurDuration: style.blurDuration,
                            enabled: style.blurEnabled,
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
