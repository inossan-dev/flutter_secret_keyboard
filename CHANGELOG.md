# CHANGELOG

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