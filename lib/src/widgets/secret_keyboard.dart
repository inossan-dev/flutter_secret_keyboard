import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';
import 'package:flutter_secret_keyboard/src/widgets/touch_effect_factory.dart';

import 'secret_keyboard_item.dart';

/// Widget principal du clavier secret refactorisé
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

  const SecretKeyboard({
    super.key,
    required this.controller,
    required this.onClick,
    this.showSecretCode = DefaultValues.showSecretCode,
    this.showGrid = DefaultValues.showGrid,
    this.onCodeCompleted,
    this.onFingerprintClick,
    this.onCanCleanMessage,
    this.height,
    this.width,
    this.deleteButtonWidget,
    this.fingerprintButtonWidget,
    this.textController,
    this.obscureText = DefaultValues.obscureText,
    this.obscuringCharacter = DefaultValues.obscuringCharacter,
    this.inputFormatters,
    this.style,
    this.theme,
    this.backgroundColor,
    this.cellTextStyle,
    this.touchEffect,
    this.showBorders,
  });

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
  SecretKeyboardTextFieldBinding? _textFieldBinding;

  @override
  void initState() {
    super.initState();

    // Utilisation du builder pour créer la liaison
    _textFieldBinding = TextFieldBindingBuilder.build(
      keyboardController: widget.controller,
      textController: widget.textController,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      inputFormatters: widget.inputFormatters,
    );

    // S'abonner aux changements d'état
    widget.controller.addListener(_handleStateChange);
  }

  @override
  void didUpdateWidget(SecretKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Gérer les changements de controller
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleStateChange);
      widget.controller.addListener(_handleStateChange);
    }

    // Utilisation du builder pour vérifier si une mise à jour est nécessaire
    if (TextFieldBindingBuilder.hasConfigurationChanged(
      oldTextController: oldWidget.textController,
      newTextController: widget.textController,
      oldObscureText: oldWidget.obscureText,
      newObscureText: widget.obscureText,
      oldObscuringCharacter: oldWidget.obscuringCharacter,
      newObscuringCharacter: widget.obscuringCharacter,
      oldInputFormatters: oldWidget.inputFormatters,
      newInputFormatters: widget.inputFormatters,
    )) {
      // Disposition de l'ancienne liaison et création d'une nouvelle
      _textFieldBinding?.dispose();

      _textFieldBinding = TextFieldBindingBuilder.build(
        keyboardController: widget.controller,
        textController: widget.textController,
        obscureText: widget.obscureText,
        obscuringCharacter: widget.obscuringCharacter,
        inputFormatters: widget.inputFormatters,
      );
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleStateChange);
    _textFieldBinding?.dispose();
    super.dispose();
  }

  /// Gérer les changements d'état du controller
  void _handleStateChange() {
    // L'état est maintenant géré par le controller
    // Cette méthode peut être utilisée pour des mises à jour spécifiques du widget si nécessaire
  }

  void resetKeyboard() {
    widget.controller.resetSecretCode();
  }

  void handleKeyPress(String keyValue) {
    final normalizedKey = SecretKeyboardConstants.convertLegacyKey(keyValue);

    // Le controller gère maintenant la logique de completion
    String newCode = widget.controller.formSecretCode(keyValue);

    widget.onClick(newCode);

    // Vérifier l'état de completion depuis le controller
    if (!widget.controller.isCompleted &&
        widget.onCodeCompleted != null &&
        newCode.isNotEmpty &&
        newCode.length == widget.controller.maxLength) {
      widget.onCodeCompleted!(newCode);
    }

    if (widget.onFingerprintClick != null &&
        normalizedKey == SecretKeyboardConstants.FINGERPRINT_KEY) {
      widget.onFingerprintClick!(newCode);
    }

    if (widget.onCanCleanMessage != null && newCode.length == 1) {
      widget.onCanCleanMessage!(true);
    }
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

    final bool isLastRow = index >= widget.controller.secretKeyboardData.length - widget.controller.gridColumns;
    final bool isLastColumn = (index + 1) % widget.controller.gridColumns == 0;

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

  /// Crée un widget avec l'effet tactile approprié
  Widget _buildKeyWithTouchEffect({
    required Widget keyContainer,
    required VoidCallback onTap,
    required SecretKeyboardStyle style,
  }) {
    return TouchEffectFactory.createTouchEffectWidget(
      effect: style.touchEffect,
      child: keyContainer,
      onTap: onTap,
      style: style,
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
                      crossAxisCount: widget.controller.gridColumns,
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

                      void onTap() {
                        String keyValue = widget.controller.secretKeyboardData[index].key;
                        handleKeyPress(keyValue);
                      }

                      // Utilisation de la factory pour créer le widget avec effet tactile
                      return _buildKeyWithTouchEffect(
                        keyContainer: keyContainer,
                        onTap: onTap,
                        style: style,
                      );
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