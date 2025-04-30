import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';
import 'package:flutter_secret_keyboard/src/utils/constants.dart';

/// Contrôleur qui gère l'état et la logique du clavier secret
class SecretKeyboardController with ChangeNotifier {
  /// Fonction d'authentification actuelle
  AuthenticationFunction _authenticationFunction;

  /// Permet de vérifier si l'empreinte digitale est activée
  final bool _fingerprintEnabled;

  /// Détermine si les touches sont mélangées aléatoirement
  final bool _randomizeKeys;

  /// Constructeur du contrôleur
  SecretKeyboardController({
    AuthenticationFunction authenticationFunction = AuthenticationFunction.transactionValidation,
    bool fingerprintEnabled = false,
    int maxLength = SecretKeyboardConstants.PIN_CODE_LENGTH,
    bool randomizeKeys = true,
  }) :
        _authenticationFunction = authenticationFunction,
        _fingerprintEnabled = fingerprintEnabled,
        _maxLength = maxLength,
        _randomizeKeys = randomizeKeys {
    // Initialisation des données
    initSecretCode();
    initSecretKeyboard();
  }

  /// Obtenir la fonction d'authentification actuelle
  AuthenticationFunction get authenticationFunction => _authenticationFunction;

  /// Liste des données du code secret (les indicateurs de saisie)
  List<SecretCodeData> _secretCodeDatas = [];

  /// Getter pour la liste des données du code secret
  List<SecretCodeData> get secretCodeDatas => _secretCodeDatas;

  /// Longueur maximale du code
  int _maxLength = SecretKeyboardConstants.PIN_CODE_LENGTH;

  /// Getter pour obtenir la longueur maximale du code
  int get maxLength => _maxLength;

  /// Code secret actuel
  String _secretCode = '';

  /// Getter pour le code secret
  String get secretCode => _secretCode;

  /// Liste des données du clavier
  List<SecretKeyboardData> _secretKeyboardData = [];

  /// Getter pour la liste des données du clavier
  List<SecretKeyboardData> get secretKeyboardData => _secretKeyboardData;

  /// Réinitialiser le code secret
  void resetSecretCode({
    String initCode = '',
    int? maxLength
  }) {
    if (maxLength != null) {
      _maxLength = maxLength;
    }

    updateSecretCode('');
    _secretCode = initCode;
    notifyListeners();
  }

  /// Initialiser les indicateurs du code secret
  void initSecretCode() {
    _secretCodeDatas = List.generate(
        _maxLength,
            (index) => SecretCodeData(isActive: false)
    );
    notifyListeners();
  }

  /// Mettre à jour les indicateurs du code secret
  void updateSecretCode(String code) {
    int codeLength = code.length;
    _secretCodeDatas = List.generate(
        _maxLength,
            (i) => SecretCodeData(isActive: (i < codeLength))
    );
    notifyListeners();
  }

  /// Former le code secret en ajoutant un caractère
  String formSecretCode(String key) {
    if (key.isEmpty || key == " ") {
      return _secretCode;
    }

    if (key != SecretKeyboardConstants.DELETE_KEY &&
        key != SecretKeyboardConstants.FINGERPRINT_KEY) {
      // Ajout d'un chiffre
      if (_secretCode.isNotEmpty && _secretCode.length == _maxLength) {
        return _secretCode;
      }
      _secretCode += key;
    } else if (key == SecretKeyboardConstants.FINGERPRINT_KEY) {
      // Empreinte digitale (action gérée par l'appelant)
    } else if (key == SecretKeyboardConstants.DELETE_KEY) {
      // Suppression d'un chiffre
      if (_secretCode.isNotEmpty) {
        _secretCode = _secretCode.substring(0, _secretCode.length - 1);
      }
    }

    // Mettre à jour les indicateurs visuels en fonction du nouveau code
    updateSecretCode(_secretCode);

    return _secretCode;
  }

  /// Initialiser le clavier avec des chiffres dans un ordre standard ou aléatoire
  void initSecretKeyboard() {
    List<String> keys = List.generate(10, (i) => "$i");
    List<String> orderedKeys;

    if (_randomizeKeys) {
      // Mélanger tous les chiffres si l'option est activée
      orderedKeys = _shuffle(keys);
    } else {
      // Ordre standard (avec 9 et 0 pour la dernière rangée)
      orderedKeys = [];

      // Les 8 premiers chiffres (1-8) pour les 2 premières rangées
      for (int i = 1; i <= 8; i++) {
        orderedKeys.add("$i");
      }

      // Les chiffres 9 et 0 seront placés séparément dans la dernière rangée
    }

    // Créer la liste du clavier
    List<SecretKeyboardData> listSecretKeyboard = [];

    // Si mode mélangé, ajouter les 8 premiers chiffres (qui sont aléatoires)
    // Sinon, ajouter les chiffres 1-8 dans l'ordre
    for (int i = 0; i < 8; i++) {
      listSecretKeyboard.add(SecretKeyboardData(key: orderedKeys[i]));
    }

    // Dernière rangée : [FP/vide][9][0][DL]

    // 1. Ajouter l'emplacement pour l'empreinte digitale ou un espace vide
    if (_fingerprintEnabled) {
      listSecretKeyboard.add(SecretKeyboardData(key: SecretKeyboardConstants.FINGERPRINT_KEY));
    } else {
      listSecretKeyboard.add(SecretKeyboardData(key: SecretKeyboardConstants.EMPTY_KEY));
    }

    // 2. Ajouter les deux derniers chiffres (9 et 0 pour le mode standard, ou les derniers chiffres mélangés)
    if (_randomizeKeys) {
      listSecretKeyboard.add(SecretKeyboardData(key: orderedKeys[8]));
      listSecretKeyboard.add(SecretKeyboardData(key: orderedKeys[9]));
    } else {
      listSecretKeyboard.add(SecretKeyboardData(key: "9"));
      listSecretKeyboard.add(SecretKeyboardData(key: "0"));
    }

    // 3. Ajouter le bouton de suppression
    listSecretKeyboard.add(SecretKeyboardData(key: SecretKeyboardConstants.DELETE_KEY));

    _secretKeyboardData = listSecretKeyboard;
    notifyListeners();
  }

  /// Mélanger une liste de manière aléatoire
  List<String> _shuffle(List<String> items) {
    var random = Random();

    // Parcourir tous les éléments
    for (var i = items.length - 1; i > 0; i--) {
      // Choisir un nombre pseudoaléatoire selon la longueur de la liste
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  /// Libérer les ressources lors de la destruction
  @override
  void dispose() {
    _secretCode = '';
    _secretCodeDatas.clear();
    _secretKeyboardData.clear();
    super.dispose();
  }
}
