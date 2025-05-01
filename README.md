# Flutter Secret Keyboard

Une bibliothèque Flutter pour implémenter un clavier de saisie de code secret sécurisé avec disposition aléatoire des touches.

## Caractéristiques

- Clavier numérique avec disposition aléatoire des touches pour une sécurité accrue
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
  flutter_secret_keyboard: ^1.0.2
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
class PreventLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, 
    TextEditingValue newValue
  ) {
    // Si la nouvelle valeur est un '0' seul et qu'on commence une saisie
    if (newValue.text == '0' && oldValue.text.isEmpty) {
      return oldValue; // Rejeter le '0' initial
    }
    
    // Si on a un '0' suivi d'autres chiffres (ex: '01'), le remplacer par les chiffres qui suivent
    if (newValue.text.startsWith('0') && newValue.text.length > 1) {
      final sanitized = newValue.text.replaceFirst(RegExp(r'^0+'), '');
      return TextEditingValue(
        text: sanitized,
        selection: TextSelection.collapsed(offset: sanitized.length),
      );
    }
    
    // Sinon, accepter la valeur
    return newValue;
  }
}

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
