import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';
import 'package:flutter_secret_keyboard/src/utils/validation_utils.dart';

/// Contrôleur amélioré qui gère l'état complet du clavier secret
class SecretKeyboardController with ChangeNotifier {
  /// Fonction d'authentification actuelle
  final AuthenticationFunction _authenticationFunction;

  /// Permet de vérifier si l'empreinte digitale est activée
  final bool _fingerprintEnabled;

  /// Détermine si les touches sont mélangées aléatoirement
  final bool _randomizeKeys;

  /// Nombre de colonnes du clavier (3 ou 4)
  final int _gridColumns;

  /// Indique si le code est complété
  bool _isCompleted = false;

  /// Constructeur du contrôleur
  SecretKeyboardController({
    AuthenticationFunction authenticationFunction = AuthenticationFunction.transactionValidation,
    bool fingerprintEnabled = false,
    int maxLength = SecretKeyboardConstants.PIN_CODE_LENGTH,
    bool randomizeKeys = true,
    int gridColumns = 4,
  }) :
        _authenticationFunction = authenticationFunction,
        _fingerprintEnabled = fingerprintEnabled,
        _maxLength = ValidationUtils.validateMaxLength(maxLength),
        _randomizeKeys = randomizeKeys,
        _gridColumns = ValidationUtils.validateGridColumns(gridColumns) {
    // Initialisation des données
    initSecretCode();
    initSecretKeyboard();
  }

  /// Obtenir la fonction d'authentification actuelle
  AuthenticationFunction get authenticationFunction => _authenticationFunction;

  /// Obtenir le nombre de colonnes
  int get gridColumns => _gridColumns;

  /// Obtenir l'état de completion
  bool get isCompleted => _isCompleted;

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

  /// Définir une nouvelle valeur pour le code secret
  ///
  /// Met également à jour les indicateurs visuels en fonction du nouveau code
  void setSecretCode(String newCode) {
    // Validation de la longueur maximale
    String validatedCode = newCode;
    if (newCode.length > _maxLength) {
      validatedCode = newCode.substring(0, _maxLength);
    }

    if (_secretCode != validatedCode) {
      _secretCode = validatedCode;
      updateSecretCode(validatedCode);
      _updateCompletionStatus();
      notifyListeners();
    }
  }

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
    _isCompleted = false;
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
  /// Forme le code secret en utilisant la nouvelle nomenclature
  String formSecretCode(String keyValue) {
    // Conversion automatique pour la rétrocompatibilité
    final normalizedKey = SecretKeyboardConstants.convertLegacyKey(keyValue);

    if (normalizedKey == SecretKeyboardConstants.DELETE_KEY) {
      if (_secretCode.isNotEmpty) {
        _secretCode = _secretCode.substring(0, _secretCode.length - 1);
        _secretCodeDatas = _secretCodeStateUpdate();
        _isCompleted = false; // Réinitialiser l'état de completion
        notifyListeners();
      }
    } else if (normalizedKey != SecretKeyboardConstants.FINGERPRINT_KEY &&
        normalizedKey != SecretKeyboardConstants.EMPTY_KEY &&
        !_isCompleted) { // Vérifier si le code n'est pas déjà complété
      if (_secretCode.length < _maxLength) {
        _secretCode += normalizedKey;
        _secretCodeDatas = _secretCodeStateUpdate();
        _updateCompletionStatus();
        notifyListeners();
      }
    }

    return _secretCode;
  }

  /// Mettre à jour l'état de completion
  void _updateCompletionStatus() {
    bool wasCompleted = _isCompleted;
    _isCompleted = _secretCode.length == _maxLength;

    if (_isCompleted != wasCompleted) {
      notifyListeners();
    }
  }

  /// Former le code secret en ajoutant un caractère
  List<SecretCodeData> _secretCodeStateUpdate() {
    List<SecretCodeData> newSecretCodeDatas = [];
    for (int i = 0; i < _maxLength; i++) {
      if (i < _secretCode.length) {
        newSecretCodeDatas.add(SecretCodeData(isActive: true));
      } else {
        newSecretCodeDatas.add(SecretCodeData(isActive: false));
      }
    }
    return newSecretCodeDatas;
  }

  /// Initialiser le clavier avec les nouvelles structures de données
  void initSecretKeyboard() {
    List<String> keys = List<String>.generate(10, (i) => "$i");
    List<String> orderedKeys = _randomizeKeys ? _shuffle(keys) : [];

    List<SecretKeyboardData> listSecretKeyboard = [];

    // Configuration selon le nombre de colonnes
    KeyboardConfiguration config = _getKeyboardConfiguration();

    // Ajouter les touches numériques principales
    listSecretKeyboard.addAll(_generateNumericKeys(orderedKeys, config));

    // Ajouter les touches spéciales dans l'ordre défini
    for (var specialKey in config.specialKeysOrder) {
      listSecretKeyboard.add(_createSpecialKey(specialKey, orderedKeys));
    }

    _secretKeyboardData = listSecretKeyboard;
    notifyListeners();
  }

  /// Génère les touches numériques selon la configuration
  List<SecretKeyboardData> _generateNumericKeys(
      List<String> orderedKeys,
      KeyboardConfiguration config,
      ) {
    List<SecretKeyboardData> numericKeys = [];

    for (int i = 0; i < config.numericKeysCount; i++) {
      String keyValue = _randomizeKeys
          ? orderedKeys[i]
          : config.getNumericKeyValue(i);

      numericKeys.add(SecretKeyboardData.numeric(keyValue));
    }

    return numericKeys;
  }

  /// Crée une touche spéciale selon son type
  SecretKeyboardData _createSpecialKey(
      SpecialKeyType type,
      List<String> orderedKeys,
      ) {
    switch (type) {
      case SpecialKeyType.fingerprint:
        return _fingerprintEnabled
            ? SecretKeyboardData.fingerprint()
            : SecretKeyboardData.empty();

      case SpecialKeyType.lastNumeric:
        String keyValue = _randomizeKeys
            ? orderedKeys[_gridColumns == 3 ? 9 : 8]
            : (_gridColumns == 3 ? "0" : "9");
        return SecretKeyboardData.numeric(keyValue);

      case SpecialKeyType.zeroKey:
        String keyValue = _randomizeKeys ? orderedKeys[9] : "0";
        return SecretKeyboardData.numeric(keyValue);

      case SpecialKeyType.delete:
        return SecretKeyboardData.delete();
    }
  }

  /// Retourne la configuration appropriée selon le nombre de colonnes
  KeyboardConfiguration _getKeyboardConfiguration() {
    return _gridColumns == 3
        ? KeyboardConfiguration.threeColumns()
        : KeyboardConfiguration.fourColumns();
  }

  /// Méthode de migration pour les configurations existantes
  void migrateKeyConfiguration() {
    _secretKeyboardData = _secretKeyboardData.map((data) {
      if (KeyMigrationHelper.isLegacyKey(data.key)) {
        return KeyMigrationHelper.migrateKeyData(data.key);
      }
      return data;
    }).toList();

    notifyListeners();
  }


  /// Mélanger une liste de manière aléatoire
  List<String> _shuffle(List<String> items) {
    // Créer une copie pour éviter de modifier la liste originale
    List<String> shuffled = List<String>.from(items);
    var random = Random();

    for (var i = shuffled.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = shuffled[i];
      shuffled[i] = shuffled[n];
      shuffled[n] = temp;
    }

    return shuffled;
  }

  /// Libérer les ressources lors de la destruction
  @override
  void dispose() {
    _secretCode = '';
    _secretCodeDatas.clear();
    _secretKeyboardData.clear();
    _isCompleted = false;
    super.dispose();
  }
}