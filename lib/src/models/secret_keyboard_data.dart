/// Classe représentant une touche sur le clavier secret
class SecretKeyboardData {
  /// Valeur de la touche (chiffre ou commande spéciale comme "D" pour supprimer)
  final String key;

  /// Constructeur qui prend une clé obligatoire
  SecretKeyboardData({
    required this.key,
  });
}