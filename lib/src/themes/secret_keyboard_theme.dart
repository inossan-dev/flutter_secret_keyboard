import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

class SecretKeyboardTheme {
  // Propriétés essentielles
  final KeyTouchEffect touchEffect;
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final bool showBorders;
  final bool showOuterBorder;

  // Propriétés optionnelles pour certains thèmes spécifiques
  final Color? secondaryColor;
  final TextStyle? textStyle;
  final Duration? animationDuration;
  final Color? borderColor;
  final double? blurIntensity;
  final Duration? blurDuration;
  final bool? blurEnabled;

  const SecretKeyboardTheme({
    required this.touchEffect,
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
    this.showBorders = false,
    this.showOuterBorder = false,
    this.secondaryColor,
    this.textStyle,
    this.animationDuration,
    this.borderColor,
    this.blurIntensity,
    this.blurDuration,
    this.blurEnabled,
  });

  /// Convertit ce thème en style complet
  SecretKeyboardStyle toStyle() {
    return SecretKeyboardStyle(
      cellTextStyle: textStyle ?? TextStyle(
        fontSize: 24,
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      deleteIconStyle: TextStyle(color: textColor, fontSize: 30),
      fingerprintIconStyle: TextStyle(color: textColor, fontSize: 30),
      backgroundColor: backgroundColor,
      indicatorActiveColor: primaryColor,
      indicatorInactiveColor: secondaryColor ?? textColor.withValues(alpha: 0.4),
      indicatorBackgroundColor: backgroundColor,
      touchEffect: touchEffect,
      touchEffectColor: primaryColor,
      touchEffectDuration: animationDuration ?? const Duration(milliseconds: 150),
      touchEffectScaleValue: 0.95,
      showBorders: showBorders,
      showOuterBorder: showOuterBorder,
      borderColor: borderColor ?? primaryColor.withValues(alpha: 0.3),
      borderWidth: 1.0,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      blurIntensity: blurIntensity ?? 3.0,
      blurDuration: blurDuration ?? const Duration(milliseconds: 300),
      blurEnabled: blurEnabled ?? true,
      cellAspectRatio: 1.0,
      horizontalPadding: 100,
      indicatorSize: 20,
      borderPadding: 1,
    );
  }

  /// Méthode pour créer une copie modifiée
  SecretKeyboardTheme copyWith({
    KeyTouchEffect? touchEffect,
    Color? primaryColor,
    Color? backgroundColor,
    Color? textColor,
    bool? showBorders,
    bool? showOuterBorder,
    Color? secondaryColor,
    TextStyle? textStyle,
    Duration? animationDuration,
    Color? borderColor,
    double? blurIntensity,
    Duration? blurDuration,
    bool? blurEnabled,
  }) {
    return SecretKeyboardTheme(
      touchEffect: touchEffect ?? this.touchEffect,
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      showBorders: showBorders ?? this.showBorders,
      showOuterBorder: showOuterBorder ?? this.showOuterBorder,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      textStyle: textStyle ?? this.textStyle,
      animationDuration: animationDuration ?? this.animationDuration,
      borderColor: borderColor ?? this.borderColor,
      blurIntensity: blurIntensity ?? this.blurIntensity,
      blurDuration: blurDuration ?? this.blurDuration,
      blurEnabled: blurEnabled ?? this.blurEnabled,
    );
  }

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
    borderColor: Color(0x80CCCCCC),
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
    borderColor: Color(0x80CCCCCC),
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
    borderColor: Color(0x80CCCCCC),
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
      fontFamily: '.SF Pro Text',
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
    borderColor: Color(0x40007AFF),
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
    borderColor: Color(0x400DFF9C),
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

  /// Thème avec effet gélatineux - style moderne ludique
  static const SecretKeyboardTheme jellyModern = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.jelly,
    primaryColor: Color(0xFF6366F1),
    backgroundColor: Colors.white,
    textColor: Color(0xFF1F2937),
    textStyle: TextStyle(
      fontSize: 26,
      color: Color(0xFF1F2937),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    animationDuration: Duration(milliseconds: 400),
  );

  /// Thème avec effet gélatineux - style coloré et fun
  static const SecretKeyboardTheme jellyPlayful = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.jelly,
    primaryColor: Color(0xFFEC4899),
    backgroundColor: Color(0xFFFDF2F8),
    textColor: Color(0xFF831843),
    textStyle: TextStyle(
      fontSize: 28,
      color: Color(0xFF831843),
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
    animationDuration: Duration(milliseconds: 450),
  );

  /// Thème avec effet gélatineux - style sombre
  static const SecretKeyboardTheme jellyDark = SecretKeyboardTheme(
    touchEffect: KeyTouchEffect.jelly,
    primaryColor: Color(0xFF00D9FF),
    backgroundColor: Color(0xFF1E293B),
    secondaryColor: Color(0xFF334155),
    textColor: Color(0xFFF8FAFC),
    textStyle: TextStyle(
      fontSize: 26,
      color: Color(0xFFF8FAFC),
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    animationDuration: Duration(milliseconds: 380),
  );

}
