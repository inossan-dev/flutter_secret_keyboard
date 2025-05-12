import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';
import 'package:flutter_secret_keyboard/src/constants/secret_keyboard_constants.dart';
import 'package:flutter_secret_keyboard/src/models/secret_keyboard_data.dart';
import 'package:flutter_secret_keyboard/src/utils/key_migration_helper.dart';
import 'package:flutter_secret_keyboard/src/utils/validation_utils.dart';

/// Contrôleur qui gère l'état et la logique du clavier secret
class SecretKeyboardController with ChangeNotifier {
  /// Fonction d'authentification actuelle
  final AuthenticationFunction _authenticationFunction;

  /// Permet de vérifier si l'empreinte digitale est activée
  final bool _fingerprintEnabled;

  /// Détermine si les touches sont mélangées aléatoirement
  final bool _randomizeKeys;

  /// Nombre de colonnes du clavier (3 ou 4)
  final int _gridColumns;

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
        notifyListeners();
      }
    } else if (normalizedKey != SecretKeyboardConstants.FINGERPRINT_KEY &&
        normalizedKey != SecretKeyboardConstants.EMPTY_KEY) {
      if (_secretCode.length < _maxLength) {
        _secretCode += normalizedKey;
        _secretCodeDatas = _secretCodeStateUpdate();
        notifyListeners();
      }
    }

    return _secretCode;
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
    List<String> keys = List.generate(10, (i) => "$i");
    List<String> orderedKeys;

    if (_randomizeKeys) {
      orderedKeys = _shuffle(keys);
    } else {
      orderedKeys = [];
      if (_gridColumns == 3) {
        for (int i = 1; i <= 9; i++) {
          orderedKeys.add("$i");
        }
      } else {
        for (int i = 1; i <= 8; i++) {
          orderedKeys.add("$i");
        }
      }
    }

    List<SecretKeyboardData> listSecretKeyboard = [];

    if (_gridColumns == 3) {
      // Configuration 3 colonnes
      if (_randomizeKeys) {
        for (int i = 0; i < 9; i++) {
          listSecretKeyboard.add(SecretKeyboardData.numeric(orderedKeys[i]));
        }
      } else {
        for (int i = 0; i < 9; i++) {
          listSecretKeyboard.add(SecretKeyboardData.numeric("${i + 1}"));
        }
      }

      // Dernière ligne : [FP/vide][0][DL]
      if (_fingerprintEnabled) {
        listSecretKeyboard.add(SecretKeyboardData.fingerprint());
      } else {
        listSecretKeyboard.add(SecretKeyboardData.empty());
      }

      if (_randomizeKeys) {
        listSecretKeyboard.add(SecretKeyboardData.numeric(orderedKeys[9]));
      } else {
        listSecretKeyboard.add(SecretKeyboardData.numeric("0"));
      }

      listSecretKeyboard.add(SecretKeyboardData.delete());
    } else {
      // Configuration 4 colonnes
      for (int i = 0; i < 8; i++) {
        listSecretKeyboard.add(SecretKeyboardData.numeric(
            _randomizeKeys ? orderedKeys[i] : "${i + 1}"
        ));
      }

      // Dernière ligne : [FP/vide][9][0][DL]
      if (_fingerprintEnabled) {
        listSecretKeyboard.add(SecretKeyboardData.fingerprint());
      } else {
        listSecretKeyboard.add(SecretKeyboardData.empty());
      }

      if (_randomizeKeys) {
        listSecretKeyboard.add(SecretKeyboardData.numeric(orderedKeys[8]));
        listSecretKeyboard.add(SecretKeyboardData.numeric(orderedKeys[9]));
      } else {
        listSecretKeyboard.add(SecretKeyboardData.numeric("9"));
        listSecretKeyboard.add(SecretKeyboardData.numeric("0"));
      }

      listSecretKeyboard.add(SecretKeyboardData.delete());
    }

    _secretKeyboardData = listSecretKeyboard;
    notifyListeners();
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
