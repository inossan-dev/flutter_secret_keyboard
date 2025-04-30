# Flutter Secret Keyboard

Une bibliothèque Flutter pour implémenter un clavier de saisie de code secret sécurisé avec disposition aléatoire des touches.

## Caractéristiques

- Clavier numérique avec disposition aléatoire des touches pour une sécurité accrue
- Option pour activer ou désactiver le mélange aléatoire des touches
- Liaison avec un TextField pour afficher le code saisi
- Support pour l'authentification par empreinte digitale
- Indicateurs visuels de saisie du code
- Hautement personnalisable (couleurs, styles, icônes)
- Aucune dépendance externe
- Support des fonctions de rappel pour différentes actions (code complété, empreinte digitale, etc.)

## Installation

Ajoutez `flutter_secret_keyboard` à votre fichier pubspec.yaml :

```yaml
dependencies:
  flutter_secret_keyboard: ^1.0.0
```

## Utilisation

Voici un exemple simple d'utilisation de la bibliothèque :

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
  String _enteredCode = '';

  @override
  void initState() {
    super.initState();
    _controller = SecretKeyboardController(
      fingerprintEnabled: true,     // Activer le bouton d'empreinte digitale
      maxLength: 4,                 // Définir la longueur du code à 4 chiffres
      randomizeKeys: true,          // Activer le mélange aléatoire des touches
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
            textController: _textController,  // Liaison avec le TextField
            obscureText: true,               // Masquer le texte
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

## Personnalisation

Le clavier est hautement personnalisable. Voici quelques exemples :

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

### Couleurs des indicateurs

```dart
SecretKeyboard(
  controller: _controller,
  indicatorActiveColor: Colors.blue,    // Couleur des indicateurs actifs
  indicatorInactiveColor: Colors.grey,  // Couleur des indicateurs inactifs
  indicatorBackgroundColor: Colors.white, // Couleur de fond des indicateurs
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
  bool randomizeKeys = true,  // Nouvelle option pour le mélange des touches
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
  // Nouveaux paramètres pour la liaison avec TextField
  TextEditingController? textController,
  bool obscureText = true,
  String obscuringCharacter = '•',
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
})
```

## Licence

MIT