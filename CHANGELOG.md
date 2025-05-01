# CHANGELOG

## 1.2.0 (01 mai 2025)

### Ajouts

- Configuration du nombre de colonnes du clavier (3 ou 4) pour s'adapter à différentes mises en page

### Améliorations

- Adaptation intelligente du clavier en fonction du nombre de colonnes sélectionné

## 1.1.0 (30 avril 2025)

### Améliorations

- Mise à jour des contraintes de compatibilité : Dart SDK >=2.17.0 <4.0.0 et Flutter >=2.10.0
- Amélioration du traitement des zéros initiaux avec `PreventLeadingZeroFormatter`
- Optimisation des performances avec les inputFormatters complexes
- Meilleure compatibilité avec les versions plus anciennes de Dart et Flutter

### Corrections

- Correction du problème de non-prise en compte du `FilteringTextInputFormatter.deny(RegExp(r'^0'))`
- Amélioration de la gestion des suppressions lors de l'utilisation des formatters
- Optimisation de la synchronisation entre le controller et le texte formaté

## 1.0.1 (30 avril 2025)

### Ajouts

- Support pour les `inputFormatters` sur le TextField lié au clavier secret
- Possibilité d'appliquer des contraintes de formatage au texte saisi
- Prise en charge de formatters personnalisés pour des formats spécifiques (XX-XXXX, etc.)
- Support complet de l'API standard de Flutter `TextInputFormatter`

### Améliorations

- Traitement optimisé des entrées dans la liaison TextField
- Meilleure gestion de la position du curseur après l'application des formatters
- Compatibilité avec les formatters standard de Flutter (`LengthLimitingTextInputFormatter`, `FilteringTextInputFormatter`, etc.)

## 1.0.0 (30 avril 2025)

### Ajouts

- Création d'une bibliothèque de clavier secret autonome pour Flutter
- Implémentation d'un clavier numérique avec disposition aléatoire des touches pour une sécurité accrue
- Ajout d'une option pour activer/désactiver le mélange aléatoire des touches
- Support pour l'authentification par empreinte digitale
- Indicateurs visuels de saisie du code
- Liaison avec un TextField pour afficher le code saisi
- Personnalisation complète de l'apparence (couleurs, styles, icônes)
- Support des fonctions de rappel pour différentes actions (code complété, empreinte digitale)
- Gestion configurable de la longueur du code PIN

### Caractéristiques techniques

- Architecture sans dépendance externe
- Séparation claire des responsabilités (modèles, contrôleur, widgets)
- Utilisation du système standard de gestion d'état de Flutter avec `ChangeNotifier`
- Compatibilité avec Flutter 2.x et 3.x via une implémentation personnalisée de `ListenableBuilder`
- Support pour la synchronisation bidirectionnelle entre le clavier secret et un TextField standard
- Filtrage automatique des entrées non numériques dans la méthode `syncFromTextField`

### Corrections

- Résolution des problèmes d'affichage des indicateurs lors de la saisie du code
- Correction de l'ordre des touches en mode non mélangé (9 et 0 correctement placés)
- Résolution des conflits entre la propriété `obscureText` du TextField et celle du clavier secret

### Documentation

- Documentation complète avec exemples d'utilisation
- Guide détaillé pour la personnalisation du clavier
- Instructions pour l'intégration dans les applications existantes
- Exemples de cas d'utilisation avancés (double saisie, pré-remplissage)

Cette première version établit les fondations d'une bibliothèque flexible et sécurisée pour la saisie de codes secrets dans les applications Flutter, tout en offrant une expérience utilisateur personnalisable et intuitive.
