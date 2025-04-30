/// Classe représentant l'état d'un chiffre du code secret
class SecretCodeData {
  /// Indique si cette position est active (remplie)
  final bool isActive;

  /// Constructeur avec valeur par défaut
  SecretCodeData({
    this.isActive = false,
  });
}

/// Classe contenant une liste de données de code secret
class ListSecretCodeData {
  /// Liste des données du code secret
  final List<SecretCodeData>? listSecretCodeData;

  /// Constructeur qui prend une liste de SecretCodeData
  ListSecretCodeData(this.listSecretCodeData);
}