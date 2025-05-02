import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

class SecretKeyboardTheme {
  /// Type d'effet tactile
  final KeyTouchEffect touchEffect;

  /// Couleur principale du thème
  final Color primaryColor;

  /// Couleur secondaire du thème
  final Color? secondaryColor;

  /// Couleur de fond
  final Color backgroundColor;

  /// Couleur du texte
  final Color textColor;

  /// Style du texte
  final TextStyle? textStyle;

  /// Durée de l'animation
  final Duration animationDuration;

  /// Afficher les bordures/séparateurs entre les touches
  final bool showBorders;

  /// Afficher une bordure externe autour du clavier entier
  final bool showOuterBorder;

  /// Couleur des bordures (si showBorders ou showOuterBorder est true)
  final Color? borderColor;

  /// Intensité du flou (lorsque touchEffect est KeyTouchEffect.blur)
  final double blurIntensity;

  /// Durée de l'effet de flou
  final Duration blurDuration;

  /// Activation de l'effet de flou
  final bool blurEnabled;

  /// Constructeur de thème personnalisé
  const SecretKeyboardTheme({
    required this.touchEffect,
    required this.primaryColor,
    this.secondaryColor,
    required this.backgroundColor,
    required this.textColor,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 150),
    this.showBorders = false,
    this.showOuterBorder = false,
    this.borderColor,
    this.blurIntensity = BlurEffectConstants.DEFAULT_BLUR_INTENSITY,
    this.blurDuration = BlurEffectConstants.DEFAULT_BLUR_DURATION,
    this.blurEnabled = true,
  });

  /// Thème avec bordures internes seulement
  static const SecretKeyboardTheme gridLines = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.none,
    primaryColor: Colors.blue,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    textStyle: TextStyle(
      fontSize: 24,
      color: Colors.black87,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
    showBorders: true,
    showOuterBorder: false,
    borderColor: Color(0x80CCCCCC), // Gris semi-transparent
  );

  /// Thème avec bordures internes et externes
  static const SecretKeyboardTheme fullGrid = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.none,
    primaryColor: Colors.blue,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    textStyle: TextStyle(
      fontSize: 24,
      color: Colors.black87,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
    showBorders: true,
    showOuterBorder: true,
    borderColor: Color(0x80CCCCCC), // Gris semi-transparent
  );

  /// Thème Material Design moderne - sans bordures
  static const SecretKeyboardTheme material = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.ripple,
    primaryColor: Colors.blue,
    backgroundColor: Colors.transparent,
    textColor: Colors.black,
    textStyle: TextStyle(
      fontSize: 24,
      color: Colors.black87,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
    showBorders: false,
  );

  /// Thème Material Design moderne - avec bordures
  static const SecretKeyboardTheme materialWithBorders = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.ripple,
    primaryColor: Colors.blue,
    backgroundColor: Colors.transparent,
    textColor: Colors.black,
    textStyle: TextStyle(
      fontSize: 24,
      color: Colors.black87,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
    showBorders: true,
    borderColor: Color(0x80CCCCCC), // Gris semi-transparent
  );

  /// Thème neumorphique - effet d'élévation subtil
  static const SecretKeyboardTheme neumorphic = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.elevation,
    primaryColor: Color(0xFF6200EE),
    backgroundColor: Color(0xFFF0F0F0),
    textColor: Colors.black87,
    textStyle: TextStyle(
      fontSize: 22,
      color: Color(0xFF424242),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );

  /// Thème iOS - effets minimalistes
  static const SecretKeyboardTheme iOS = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.scale,
    primaryColor: Color(0xFF007AFF),
    backgroundColor: Colors.white,
    textColor: Colors.black,
    textStyle: TextStyle(
      fontSize: 25,
      color: Colors.black87,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      fontFamily: '.SF Pro Text',  // Si disponible
    ),
  );

  /// Thème iOS - avec bordures
  static const SecretKeyboardTheme iOSWithBorders = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.scale,
    primaryColor: Color(0xFF007AFF),
    backgroundColor: Colors.white,
    textColor: Colors.black,
    textStyle: TextStyle(
      fontSize: 25,
      color: Colors.black87,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      fontFamily: '.SF Pro Text',
    ),
    showBorders: true,
    borderColor: Color(0x40007AFF), // Bleu iOS semi-transparent
  );

  /// Thème sombre - pour les interfaces sombres
  static const SecretKeyboardTheme dark = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.color,
    primaryColor: Color(0xFF0DFF9C),
    backgroundColor: Color(0xFF121212),
    secondaryColor: Color(0xFF2C2C2C),
    textColor: Colors.white,
    textStyle: TextStyle(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
  );

  /// Thème sombre - avec bordures
  static const SecretKeyboardTheme darkWithBorders = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.color,
    primaryColor: Color(0xFF0DFF9C),
    backgroundColor: Color(0xFF121212),
    secondaryColor: Color(0xFF2C2C2C),
    textColor: Colors.white,
    textStyle: TextStyle(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    showBorders: true,
    borderColor: Color(0x400DFF9C), // Vert néon semi-transparent
  );

  /// Thème bancaire - look sécurisé et professionnel
  static const SecretKeyboardTheme banking = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.border,
    primaryColor: Color(0xFF1F69FF),
    backgroundColor: Colors.white,
    textColor: Color(0xFF2E384D),
    textStyle: TextStyle(
      fontSize: 23,
      color: Color(0xFF2E384D),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.25,
    ),
  );

  /// Thème avec effet de flou - style moderne
  static const SecretKeyboardTheme blurredModern = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.blur,
    primaryColor: Colors.blue,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    textStyle: TextStyle(
      fontSize: 24,
      color: Colors.black87,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
    blurIntensity: 4.0,
    blurDuration: Duration(milliseconds: 350),
  );

  /// Thème avec effet de flou - style sombre
  static const SecretKeyboardTheme blurredDark = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.blur,
    primaryColor: Color(0xFF0DFF9C),
    backgroundColor: Color(0xFF121212),
    secondaryColor: Color(0xFF2C2C2C),
    textColor: Colors.white,
    textStyle: TextStyle(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    blurIntensity: 5.0,
    blurDuration: Duration(milliseconds: 400),
  );
}
