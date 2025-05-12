/// Encapsule la configuration spécifique selon le nombre de colonnes
class KeyboardConfiguration {
  final int numericKeysCount;
  final List<SpecialKeyType> specialKeysOrder;
  final String Function(int index) getNumericKeyValue;

  const KeyboardConfiguration({
    required this.numericKeysCount,
    required this.specialKeysOrder,
    required this.getNumericKeyValue,
  });

  /// Configuration pour 3 colonnes
  factory KeyboardConfiguration.threeColumns() {
    return KeyboardConfiguration(
      numericKeysCount: 9,
      specialKeysOrder: const [
        SpecialKeyType.fingerprint,
        SpecialKeyType.zeroKey,
        SpecialKeyType.delete,
      ],
      getNumericKeyValue: (index) => "${index + 1}",
    );
  }

  /// Configuration pour 4 colonnes
  factory KeyboardConfiguration.fourColumns() {
    return KeyboardConfiguration(
      numericKeysCount: 8,
      specialKeysOrder: const [
        SpecialKeyType.fingerprint,
        SpecialKeyType.lastNumeric,
        SpecialKeyType.zeroKey,
        SpecialKeyType.delete,
      ],
      getNumericKeyValue: (index) => "${index + 1}",
    );
  }
}

/// Types de touches spéciales
enum SpecialKeyType {
  fingerprint,
  lastNumeric,
  zeroKey,
  delete,
}