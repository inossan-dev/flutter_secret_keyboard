# CHANGELOG

## 1.5.0 (12 mai 2025)

### Ajouts

- Trois nouveaux effets tactiles pour enrichir l'expérience utilisateur :
  - Effet de particules : explosion colorée au toucher avec animation de gravité
  - Effet d'onde : cercles concentriques se propageant depuis la touche
  - Effet néon : halo lumineux multicouche avec pulsations caractéristiques
- Extension de l'énumération KeyTouchEffect avec particle, wave et neon
- Nouveaux thèmes prédéfinis utilisant les effets :
  - Thème "Particules festives" (particleFestive)
  - Thème "Onde aquatique" (waveAquatic)
  - Thème "Néon cyber" (neonCyber)

### Améliorations

- Optimisation de l'effet néon : meilleur contraste, bordures lumineuses visibles
- Préservation de la zone cliquable complète pour tous les nouveaux effets
- Architecture améliorée garantissant la réactivité tactile avec animations actives
- Performance optimisée pour maintenir 60 FPS avec effets complexes

## 1.4.0 (02 mai 2025)

### Ajouts

- Fonctionnalité de brouillage visuel pour une sécurité renforcée :
  - Effet de flou temporaire sur chaque touche après pression
  - Personnalisation de l'intensité et de la durée du flou
  - Option pour activer/désactiver cette fonctionnalité
- Ajout de l'effet de flou à l'énumération KeyTouchEffect
- Nouveaux thèmes prédéfinis avec effet de flou :
  - Thème "Flou moderne" (blurredModern)
  - Thème "Flou sombre" (blurredDark)

### Améliorations

- Amélioration de la sécurité visuelle pour empêcher les observateurs de voir les touches pressées
- Optimisation des animations de flou pour de meilleures performances

## 1.3.0 (01 mai 2025)

### Ajouts

- Effets tactiles pour les touches du clavier :
    - Effet d'ondulation (ripple) Material Design
    - Effet d'échelle (réduction de taille à l'appui)
    - Effet de changement de couleur
    - Effet d'élévation/ombre 3D
    - Effet d'animation de bordure
- Système de thèmes prédéfinis :
    - Material Design (ondulation)
    - Material Design avec bordures
    - Neumorphique (élévation subtile)
    - iOS (minimaliste avec échelle)
    - iOS avec bordures
    - Sombre (pour interfaces dark mode)
    - Sombre avec bordures
    - Bancaire (professionnel et sécurisé)
    - Avec bordures internes seulement (gridLines)
    - Avec bordures internes et externes (fullGrid)
- Options de personnalisation des bordures (showBorders, showOuterBorder, borderColor)
- Styles de texte personnalisés pour chaque thème
- Paramètre `touchEffectScaleValue` pour contrôler l'amplitude de l'effet d'échelle

### Améliorations

- Adaptation des icônes de suppression et d'empreinte digitale aux couleurs du thème
- Refactorisation du widget SecretCodeIndicator pour une meilleure intégration avec les thèmes
- Optimisation des transitions d'animation pour des effets plus fluides
- Meilleure gestion des bordures pour les différentes configurations de grille

## 1.2.0 (01 mai 2025)

### Ajouts

- Configuration du nombre de colonnes du clavier (3 ou 4) pour s'adapter à différentes mises en page
- Paramètre `gridColumns` dans le contrôleur et le widget pour spécifier le nombre de colonnes

### Améliorations

- Adaptation intelligente du clavier en fonction du nombre de colonnes sélectionné
- Disposition optimisée des touches numériques selon le mode 3 ou 4 colonnes

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
- Filtrage automatique des entrées non numériques

### Corrections

- Résolution des problèmes d'affichage des indicateurs lors de la saisie du code
- Correction de l'ordre des touches en mode non mélangé (9 et 0 correctement placés)
- Résolution des conflits entre la propriété `obscureText` du TextField et celle du clavier secret

### Documentation

- Documentation complète avec exemples d'utilisation
- Guide détaillé pour la personnalisation du clavier
- Instructions pour l'intégration dans les applications existantes
- Exemples de cas d'utilisation avancés (double saisie, pré-remplissage)