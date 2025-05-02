# Flutter Secret Keyboard

Une bibliothèque Flutter pour implémenter un clavier de saisie de code secret sécurisé avec disposition aléatoire des touches.

## Caractéristiques

- Clavier numérique avec disposition aléatoire des touches pour une sécurité accrue
- **Effets tactiles interactifs** (ripple, échelle, couleur, élévation, bordure, flou)
- **Brouillage visuel** des touches après pression pour une sécurité renforcée
- **Système de thèmes prédéfinis** (Material, Neumorphique, iOS, Sombre, Bancaire, Flou)
- Configuration flexible avec support pour 3 ou 4 colonnes
- Option pour activer ou désactiver le mélange aléatoire des touches
- Liaison avec un TextField pour afficher le code saisi
- Support pour les inputFormatters permettant de formater le texte saisi
- Support pour l'authentification par empreinte digitale
- Indicateurs visuels de saisie du code
- Hautement personnalisable (couleurs, styles, icônes)
- Aucune dépendance externe
- Support des fonctions de rappel pour différentes actions (code complété, empreinte digitale, etc.)

## Installation

Ajoutez `flutter_secret_keyboard` à votre fichier pubspec.yaml :

```yaml
dependencies:
  flutter_secret_keyboard: ^1.4.0
```

### Configuration requise

- Dart SDK: >=2.17.0 <4.0.0
- Flutter: >=2.10.0

## Utilisation

Voici un exemple simple d'utilisation de la bibliothèque :

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

class SecretKeyboardDemo extends StatefulWidget {
  const SecretKeyboardDemo({Key? key}) : super(key: key);

  @override
  State<SecretKeyboardDemo> createState() => _SecretKeyboardDemoState();
}

class _SecretKeyboardDemoState extends State<SecretKeyboardDemo> {
  late SecretKeyboardController _controller;
  final TextEditingController _textController = TextEditingController();
  String _enteredCode = '';

  @override
  void initState() {
    super.initState();
    _controller = SecretKeyboardController(
      fingerprintEnabled: true,     // Activer le bouton d'empreinte digitale
      maxLength: 4,                 // Définir la longueur du code à 4 chiffres
      randomizeKeys: true,          // Activer le mélange aléatoire des touches
      gridColumns: 3,               // Configurer le clavier avec 3 colonnes
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TextField lié au clavier
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _textController,
              readOnly: true,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Code PIN',
              ),
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
            ),
          ),

          const SizedBox(height: 20),

          // Clavier secret avec liaison au TextField
          SecretKeyboard(
            controller: _controller,
            codeLength: 4,
            gridColumns: 3,           // Configuration avec 3 colonnes
            textController: _textController,  // Liaison avec le TextField
            obscureText: true,               // Masquer le texte
            inputFormatters: [              // Ajout de formatters
              LengthLimitingTextInputFormatter(4),   // Limite à 4 caractères
              FilteringTextInputFormatter.digitsOnly, // Uniquement des chiffres
            ],
            onClick: (code) {
              setState(() {
                _enteredCode = code;
              });
            },
            onCodeCompleted: (code) {
              // Code complet, faire quelque chose
              print('Code complet: $code');
            },
            onFingerprintClick: (_) {
              // Lancer l'authentification par empreinte digitale
              print('Authentification par empreinte digitale demandée');
            },
            // Personnalisation des icônes
            deleteButtonWidget: const Icon(
              Icons.backspace_outlined,
              color: Colors.red,
              size: 30,
            ),
            fingerprintButtonWidget: const Icon(
              Icons.fingerprint,
              color: Colors.blue,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
```

## Nouveautés de la version 1.4.0

### Brouillage visuel

Cette fonctionnalité de sécurité applique un effet de flou temporaire sur chaque touche immédiatement après qu'elle soit pressée, rendant plus difficile pour un observateur potentiel de voir quelle touche a été utilisée.

```dart
// Utilisation de l'effet de flou
SecretKeyboard(
  controller: _controller,
  touchEffect: KeyTouchEffect.blur,    // Activer l'effet de flou
  blurIntensity: 5.0,                  // Intensité du flou (1.0 à 10.0)
  blurDuration: Duration(milliseconds: 300), // Durée de l'effet
  blurEnabled: true,                   // Activer/désactiver la fonctionnalité
  // ...
)
```

L'effet de flou peut être combiné avec d'autres mesures de sécurité comme la disposition aléatoire des touches pour une protection maximale.

### Effets tactiles

Le clavier secret propose désormais six types d'effets tactiles pour améliorer l'expérience utilisateur :

```dart
// Utilisation d'un effet tactile
SecretKeyboard(
  controller: _controller,
  touchEffect: KeyTouchEffect.scale,  // Effet d'échelle
  touchEffectColor: Colors.blue,      // Couleur de l'effet (si applicable)
  touchEffectDuration: const Duration(milliseconds: 120), // Durée de l'animation
  touchEffectScaleValue: 0.92,        // Valeur d'échelle pour l'effet scale
  // ...
)
```

Types d'effets disponibles :
- `KeyTouchEffect.none` - Aucun effet
- `KeyTouchEffect.ripple` - Effet d'ondulation Material Design
- `KeyTouchEffect.scale` - Animation de réduction d'échelle
- `KeyTouchEffect.color` - Changement de couleur
- `KeyTouchEffect.elevation` - Effet d'élévation/ombre
- `KeyTouchEffect.border` - Animation de bordure
- `KeyTouchEffect.blur` - Effet de flou temporaire

### Système de thèmes prédéfinis

```dart
// Utilisation d'un thème prédéfini
SecretKeyboard(
  controller: _controller,
  theme: SecretKeyboardTheme.banking, // Thème bancaire prédéfini
  // Les autres propriétés de style seront ignorées
  // car elles sont définies par le thème
)
```

Thèmes disponibles :
- `SecretKeyboardTheme.material` - Style Material Design moderne
- `SecretKeyboardTheme.materialWithBorders` - Material Design avec bordures
- `SecretKeyboardTheme.neumorphic` - Effet d'élévation subtil
- `SecretKeyboardTheme.iOS` - Style minimaliste inspiré d'iOS
- `SecretKeyboardTheme.iOSWithBorders` - Style iOS avec bordures
- `SecretKeyboardTheme.dark` - Thème sombre pour interfaces dark mode
- `SecretKeyboardTheme.darkWithBorders` - Thème sombre avec bordures
- `SecretKeyboardTheme.banking` - Style professionnel et sécurisé
- `SecretKeyboardTheme.gridLines` - Avec bordures internes seulement
- `SecretKeyboardTheme.fullGrid` - Avec bordures internes et externes
- `SecretKeyboardTheme.blurredModern` - Style moderne avec effet de flou
- `SecretKeyboardTheme.blurredDark` - Style sombre avec effet de flou

### Création d'un thème personnalisé

```dart
// Création d'un thème personnalisé
final monTheme = SecretKeyboardTheme(
  touchEffect: KeyTouchEffect.elevation,
  primaryColor: Colors.purple,
  secondaryColor: Colors.purple[200],
  backgroundColor: Colors.grey[100]!,
  textColor: Colors.black87,
  textStyle: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  ),
  animationDuration: const Duration(milliseconds: 150),
  showBorders: false,
  showOuterBorder: false,
  borderColor: Colors.grey.withOpacity(0.5),
  // Paramètres pour l'effet de flou
  blurIntensity: 4.0,
  blurDuration: const Duration(milliseconds: 350),
  blurEnabled: true,
);

// Utilisation du thème personnalisé
SecretKeyboard(
  controller: _controller,
  theme: monTheme,
  // ...
)
```

## Exemple complet avec thème et effets

```dart
import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

class SecretKeyboardDemo extends StatefulWidget {
  const SecretKeyboardDemo({Key? key}) : super(key: key);

  @override
  State<SecretKeyboardDemo> createState() => _SecretKeyboardDemoState();
}

class _SecretKeyboardDemoState extends State<SecretKeyboardDemo> {
  late SecretKeyboardController _controller;
  final TextEditingController _textController = TextEditingController();
  SecretKeyboardTheme _selectedTheme = SecretKeyboardTheme.material;

  @override
  void initState() {
    super.initState();
    _controller = SecretKeyboardController(
      fingerprintEnabled: true,
      maxLength: 4,
      randomizeKeys: true,
      gridColumns: 4,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clavier Sécurisé')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sélecteur de thème
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: DropdownButton<SecretKeyboardTheme>(
              value: _selectedTheme,
              isExpanded: true,
              onChanged: (theme) {
                if (theme != null) {
                  setState(() {
                    _selectedTheme = theme;
                  });
                }
              },
              items: const [
                DropdownMenuItem(
                  value: SecretKeyboardTheme.material,
                  child: Text('Thème Material'),
                ),
                DropdownMenuItem(
                  value: SecretKeyboardTheme.neumorphic,
                  child: Text('Thème Neumorphique'),
                ),
                DropdownMenuItem(
                  value: SecretKeyboardTheme.iOS,
                  child: Text('Thème iOS'),
                ),
                DropdownMenuItem(
                  value: SecretKeyboardTheme.dark,
                  child: Text('Thème Sombre'),
                ),
                DropdownMenuItem(
                  value: SecretKeyboardTheme.banking,
                  child: Text('Thème Bancaire'),
                ),
                DropdownMenuItem(
                  value: SecretKeyboardTheme.blurredModern,
                  child: Text('Thème Flou Moderne'),
                ),
                DropdownMenuItem(
                  value: SecretKeyboardTheme.blurredDark,
                  child: Text('Thème Flou Sombre'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // TextField lié au clavier
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _textController,
              readOnly: true,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Code PIN',
              ),
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
            ),
          ),

          const SizedBox(height: 20),

          // Clavier secret avec thème
          SecretKeyboard(
            controller: _controller,
            textController: _textController,
            theme: _selectedTheme,  // Utilisation du thème sélectionné
            onClick: (code) {
              // Traitement du code
            },
            onCodeCompleted: (code) {
              // Code complet, faire quelque chose
              print('Code complet: $code');
            },
            onFingerprintClick: (_) {
              // Lancer l'authentification par empreinte digitale
              print('Authentification par empreinte digitale demandée');
            },
          ),
        ],
      ),
    );
  }
}
```

## Personnalisation

Le clavier est hautement personnalisable. Voici quelques exemples :

### Configuration du nombre de colonnes

```dart
// Dans le contrôleur
SecretKeyboardController(
  gridColumns: 3,  // 3 colonnes pour une disposition téléphone
  // ...
)

// Dans le widget
SecretKeyboard(
  gridColumns: 3,  // 3 colonnes (doit correspondre au controller)
  // ...
)
```

### Mode 3 colonnes vs 4 colonnes

- **3 colonnes** : Disposition similaire au clavier téléphonique standard (1-9, puis 0)
- **4 colonnes** : Disposition élargie pour plus d'espace entre les touches

### Activation/désactivation du mélange des touches

```dart
// Dans le contrôleur
SecretKeyboardController(
  randomizeKeys: true,  // true pour mélanger, false pour l'ordre standard
  // ...
)
```

### Liaison avec un TextField

```dart
// Créer un contrôleur de texte
final TextEditingController textController = TextEditingController();

// L'utiliser avec le clavier
SecretKeyboard(
  controller: keyboardController,
  textController: textController,  // Liaison avec le TextField
  obscureText: true,              // Masquer le texte avec des points
  obscuringCharacter: '•',        // Caractère de masquage personnalisé
  // ...
)

// Important : ne pas définir obscureText sur le TextField lui-même
// car c'est géré par le SecretKeyboard
TextField(
  controller: textController,
  readOnly: true,      // Recommandé pour empêcher l'édition directe
  // Ne pas définir obscureText ici
  // ...
)
```

### Formatage du texte avec inputFormatters

```dart
// Utilisation des formatters standard de Flutter
SecretKeyboard(
  controller: keyboardController,
  textController: textController,
  inputFormatters: [
    LengthLimitingTextInputFormatter(4),    // Limite la longueur à 4 caractères
    FilteringTextInputFormatter.digitsOnly, // Accepte uniquement les chiffres
  ],
  // ...
)

// Formatter personnalisé pour empêcher le zero initial
SecretKeyboard(
  controller: keyboardController,
  textController: textController,
  inputFormatters: [
    PreventLeadingZeroFormatter(),  // Formatter inclus dans la bibliothèque
  ],
  // ...
)

// Formatter personnalisé pour un format spécifique (XX-XXXX)
class ReferenceCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, 
    TextEditingValue newValue
  ) {
    // Supprime tous les caractères non numériques
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Limite à 6 chiffres maximum
    if (newText.length > 6) {
      newText = newText.substring(0, 6);
    }
    
    // Formate selon le modèle XX-XXXX
    if (newText.length > 2) {
      newText = '${newText.substring(0, 2)}-${newText.substring(2)}';
    }
    
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

// Utilisation des formatters personnalisés
SecretKeyboard(
  controller: keyboardController,
  textController: textController,
  inputFormatters: [
    PreventLeadingZeroFormatter(),  // Empêcher le zero initial
    ReferenceCodeFormatter(),       // Formatter personnalisé pour le format XX-XXXX
  ],
  // ...
)
```

### Couleurs des indicateurs et affichage de la grille

```dart
SecretKeyboard(
  controller: _controller,
  indicatorActiveColor: Colors.blue,    // Couleur des indicateurs actifs
  indicatorInactiveColor: Colors.grey,  // Couleur des indicateurs inactifs
  indicatorBackgroundColor: Colors.white, // Couleur de fond des indicateurs
  showGrid: true,                       // Afficher la grille
  showOuterBorder: true,                // Afficher la bordure externe
  // ...
)
```

### Style des touches

```dart
SecretKeyboard(
  controller: _controller,
  backgroundColor: Colors.grey[200],  // Couleur de fond des touches
  cellStyle: const TextStyle(        // Style du texte des touches
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  ),
  // ...
)
```

### Icônes personnalisées

```dart
SecretKeyboard(
  controller: _controller,
  deleteButtonWidget: Image.asset('assets/icons/delete.png'),   // Image personnalisée
  fingerprintButtonWidget: Image.asset('assets/icons/fingerprint.png'),  // Image personnalisée
  // ...
)
```

## API principale

### SecretKeyboardController

Le contrôleur qui gère l'état du clavier.

```dart
SecretKeyboardController({
  AuthenticationFunction authenticationFunction = AuthenticationFunction.transactionValidation,
  bool fingerprintEnabled = false,
  int maxLength = 4,
  bool randomizeKeys = true,  // Option pour le mélange des touches
  int gridColumns = 4,       // Nombre de colonnes (3 ou 4)
})
```

### SecretKeyboard

Le widget principal du clavier.

```dart
SecretKeyboard({
  required SecretKeyboardController controller,
  required Function(String) onClick,
  bool showSecretCode = true,
  bool showGrid = true,
  bool showOuterBorder = false,
  double cellAspectRatio = 1,
  Function(String)? onCodeCompleted,
  Function(String)? onFingerprintClick,
  Function(bool)? onCanCleanMessage,
  double? height,
  double? width,
  Color? backgroundColor,
  TextStyle? cellStyle,
  int codeLength = 4,
  Widget? deleteButtonWidget,
  Widget? fingerprintButtonWidget,
  Color indicatorActiveColor = Colors.orange,
  Color indicatorInactiveColor = Colors.black,
  Color indicatorBackgroundColor = Colors.white,
  // Paramètres pour la liaison avec TextField
  TextEditingController? textController,
  bool obscureText = true,
  String obscuringCharacter = '•',
  // Paramètre pour le formatage du texte
  List<TextInputFormatter>? inputFormatters,
  // Paramètre pour la configuration des colonnes
  int gridColumns = 4,
  // Paramètres pour les effets tactiles
  KeyTouchEffect touchEffect = KeyTouchEffect.none,
  Color? touchEffectColor,
  Duration touchEffectDuration = const Duration(milliseconds: 150),
  double touchEffectScaleValue = 0.95,
  // Paramètres pour l'effet de flou
  double blurIntensity = 3.0,
  Duration blurDuration = const Duration(milliseconds: 300),
  bool blurEnabled = true,
  // Paramètre pour le thème
  SecretKeyboardTheme? theme,
})
```

### SecretKeyboardTheme

Classe représentant un thème pour le clavier secret.

```dart
SecretKeyboardTheme({
  required KeyTouchEffect touchEffect,
  required Color primaryColor,
  Color? secondaryColor,
  required Color backgroundColor,
  required Color textColor,
  TextStyle? textStyle,
  Duration animationDuration = const Duration(milliseconds: 150),
  bool showBorders = false,
  bool showOuterBorder = false,
  Color? borderColor,
  // Paramètres pour l'effet de flou
  double blurIntensity = 3.0,
  Duration blurDuration = const Duration(milliseconds: 300),
  bool blurEnabled = true,
})
```

### SecretKeyboardTextFieldBinding

Classe utilitaire pour lier un clavier secret à un TextField.

```dart
SecretKeyboardTextFieldBinding({
  required SecretKeyboardController keyboardController,
  required TextEditingController textEditingController,
  bool obscureText = true,
  String obscuringCharacter = '•',
  // Paramètre pour le formatage du texte
  List<TextInputFormatter>? inputFormatters,
})
```

## Licence

MIT