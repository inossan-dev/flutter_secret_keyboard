import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Démo Flutter Secret Keyboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SecretKeyboardDemoHome(),
    );
  }
}

class SecretKeyboardDemoHome extends StatefulWidget {
  const SecretKeyboardDemoHome({super.key});

  @override
  State<SecretKeyboardDemoHome> createState() => _SecretKeyboardDemoHomeState();
}

class _SecretKeyboardDemoHomeState extends State<SecretKeyboardDemoHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ThemeDemoPage(),
    const EffectsDemoPage(),
    const FormatterDemoPage(),
    const ColumnsDemoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Secret Keyboard Demo'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: 'Thèmes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'Effets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_shapes),
            label: 'Formatage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_3x3),
            label: 'Colonnes',
          ),
        ],
      ),
    );
  }
}

/// Page de démonstration des thèmes prédéfinis
class ThemeDemoPage extends StatefulWidget {
  const ThemeDemoPage({super.key});

  @override
  State<ThemeDemoPage> createState() => _ThemeDemoPageState();
}

class _ThemeDemoPageState extends State<ThemeDemoPage> {
  final TextEditingController _textController = TextEditingController();
  final SecretKeyboardController _keyboardController = SecretKeyboardController(
    fingerprintEnabled: true,
    maxLength: 6,
    randomizeKeys: true,
  );

  // Liste des thèmes disponibles
  final List<Map<String, dynamic>> _themes = [
    {'name': 'Material Design', 'theme': SecretKeyboardTheme.material},
    {'name': 'Material avec bordures', 'theme': SecretKeyboardTheme.materialWithBorders},
    {'name': 'Neumorphique', 'theme': SecretKeyboardTheme.neumorphic},
    {'name': 'iOS', 'theme': SecretKeyboardTheme.iOS},
    {'name': 'iOS avec bordures', 'theme': SecretKeyboardTheme.iOSWithBorders},
    {'name': 'Sombre', 'theme': SecretKeyboardTheme.dark},
    {'name': 'Sombre avec bordures', 'theme': SecretKeyboardTheme.darkWithBorders},
    {'name': 'Bancaire', 'theme': SecretKeyboardTheme.banking},
    {'name': 'Grille simple', 'theme': SecretKeyboardTheme.gridLines},
    {'name': 'Grille complète', 'theme': SecretKeyboardTheme.fullGrid},
    {'name': 'Flou moderne', 'theme': SecretKeyboardTheme.blurredModern},
    {'name': 'Flou sombre', 'theme': SecretKeyboardTheme.blurredDark},
    {'name': 'Gélatineux moderne', 'theme': SecretKeyboardTheme.jellyModern},
    {'name': 'Gélatineux ludique', 'theme': SecretKeyboardTheme.jellyPlayful},
    {'name': 'Gélatineux sombre', 'theme': SecretKeyboardTheme.jellyDark},
  ];

  // Thème sélectionné (par défaut: Material Design)
  int _selectedThemeIndex = 0;

  @override
  void dispose() {
    _textController.dispose();
    _keyboardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Titre explicatif
          const Text(
            'Thèmes prédéfinis',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sélectionnez un thème pour voir son apparence et son comportement.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),

          // Sélecteur de thème
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Sélectionner un thème',
              border: OutlineInputBorder(),
            ),
            value: _selectedThemeIndex,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedThemeIndex = value;
                });
              }
            },
            items: List.generate(_themes.length, (index) {
              return DropdownMenuItem<int>(
                value: index,
                child: Text(_themes[index]['name']),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Affichage du code
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Code saisi',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: 24),

          // Description du thème sélectionné
          Text(
            'Thème actuel: ${_themes[_selectedThemeIndex]['name']}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Clavier avec le thème sélectionné
          SecretKeyboard(
            controller: _keyboardController,
            textController: _textController,
            theme: _themes[_selectedThemeIndex]['theme'],
            onClick: (value) {
              // Action sur clic
            },
            onCodeCompleted: (code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Code complété: $code')),
              );
            },
            onFingerprintClick: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Authentification par empreinte digitale demandée')),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Page de démonstration des effets tactiles
class EffectsDemoPage extends StatefulWidget {
  const EffectsDemoPage({super.key});

  @override
  State<EffectsDemoPage> createState() => _EffectsDemoPageState();
}

class _EffectsDemoPageState extends State<EffectsDemoPage> {
  final TextEditingController _textController = TextEditingController();
  final SecretKeyboardController _keyboardController = SecretKeyboardController(
    maxLength: 4,
    randomizeKeys: true,
  );

  // Liste des effets tactiles disponibles
  final List<Map<String, dynamic>> _effects = [
    {'name': 'Aucun effet', 'effect': KeyTouchEffect.none},
    {'name': 'Effet d\'ondulation', 'effect': KeyTouchEffect.ripple},
    {'name': 'Effet d\'échelle', 'effect': KeyTouchEffect.scale},
    {'name': 'Effet de couleur', 'effect': KeyTouchEffect.color},
    {'name': 'Effet d\'élévation', 'effect': KeyTouchEffect.elevation},
    {'name': 'Effet de bordure', 'effect': KeyTouchEffect.border},
    {'name': 'Flou', 'effect': KeyTouchEffect.blur},
    {'name': 'Effet gélatineux', 'effect': KeyTouchEffect.jelly},
  ];

  // Effet sélectionné (par défaut: aucun)
  int _selectedEffectIndex = 0;

  // Valeur d'échelle (pour l'effet d'échelle)
  double _scaleValue = 0.95;

  // Couleur de l'effet (pour les effets qui utilisent une couleur)
  Color _effectColor = Colors.blue;

  // Durée de l'animation
  int _animationDurationMs = 150;

  // Paramètres pour l'effet de flou
  double _blurIntensity = 3.0;
  bool _blurEnabled = true;

  @override
  void dispose() {
    _textController.dispose();
    _keyboardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Titre explicatif
          const Text(
            'Effets tactiles',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sélectionnez un effet tactile et personnalisez ses paramètres.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),

          // Sélecteur d'effet
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Sélectionner un effet',
              border: OutlineInputBorder(),
            ),
            value: _selectedEffectIndex,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedEffectIndex = value;
                });
              }
            },
            items: List.generate(_effects.length, (index) {
              return DropdownMenuItem<int>(
                value: index,
                child: Text(_effects[index]['name']),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Paramètres spécifiques selon l'effet sélectionné
          if (_selectedEffectIndex == 2 || _selectedEffectIndex == 7) // Effet d'échelle et effet gélatineux
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Valeur d\'échelle:'),
                Text(
                  _selectedEffectIndex == 7
                      ? '(Pour l\'effet gélatineux, cela contrôle l\'intensité de la déformation)'
                      : '',
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
                Slider(
                  value: _scaleValue,
                  min: 0.8,
                  max: 1.0,
                  divisions: 20,
                  label: _scaleValue.toStringAsFixed(2),
                  onChanged: (value) {
                    setState(() {
                      _scaleValue = value;
                    });
                  },
                ),
              ],
            ),

          if (_selectedEffectIndex > 0) // Tous les effets sauf "Aucun"
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Durée de l\'animation (ms):'),
                Slider(
                  value: _animationDurationMs.toDouble(),
                  min: 50,
                  max: 500,
                  divisions: 45,
                  label: _animationDurationMs.toString(),
                  onChanged: (value) {
                    setState(() {
                      _animationDurationMs = value.toInt();
                    });
                  },
                ),
              ],
            ),

          if (_selectedEffectIndex == 1 || _selectedEffectIndex == 3 || _selectedEffectIndex == 5) // Effets qui utilisent une couleur
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Couleur de l\'effet:'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _colorButton(Colors.blue),
                    _colorButton(Colors.red),
                    _colorButton(Colors.green),
                    _colorButton(Colors.orange),
                    _colorButton(Colors.purple),
                  ],
                ),
              ],
            ),

          // Ajout des contrôles spécifiques pour l'effet de flou
          if (_selectedEffectIndex == 6) // Effet de flou
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Intensité du flou:'),
                Slider(
                  value: _blurIntensity,
                  min: 1.0,
                  max: 10.0,
                  divisions: 18,
                  label: _blurIntensity.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _blurIntensity = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Activer l\'effet de flou'),
                  value: _blurEnabled,
                  onChanged: (value) {
                    setState(() {
                      _blurEnabled = value;
                    });
                  },
                ),
              ],
            ),

          const SizedBox(height: 24),

          // Affichage du code
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Code saisi',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: 24),

          // Description de l'effet sélectionné
          Text(
            'Effet actuel: ${_effects[_selectedEffectIndex]['name']}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Clavier avec l'effet sélectionné - utilisant le nouveau système de style
          SecretKeyboard(
            controller: _keyboardController,
            textController: _textController,
            showGrid: false,
            style: SecretKeyboardStyle(
              touchEffect: _effects[_selectedEffectIndex]['effect'],
              touchEffectColor: _effectColor,
              touchEffectDuration: Duration(milliseconds: _animationDurationMs),
              touchEffectScaleValue: _scaleValue,
              blurIntensity: _blurIntensity,
              blurDuration: Duration(milliseconds: _animationDurationMs),
              blurEnabled: _blurEnabled,
              cellAspectRatio: 1.5,
            ),
            onClick: (value) {
              // Action sur clic
            },
            onCodeCompleted: (code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Code complété: $code')),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget pour sélectionner une couleur
  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _effectColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _effectColor == color ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (_effectColor == color)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 5,
                spreadRadius: 1,
              ),
          ],
        ),
      ),
    );
  }
}

/// Page de démonstration des formatters
class FormatterDemoPage extends StatefulWidget {
  const FormatterDemoPage({super.key});

  @override
  State<FormatterDemoPage> createState() => _FormatterDemoPageState();
}

class _FormatterDemoPageState extends State<FormatterDemoPage> {
  // Contrôleurs pour le format standard (PIN)
  final TextEditingController _pinController = TextEditingController();
  final SecretKeyboardController _pinKeyboardController = SecretKeyboardController(
    maxLength: 4,
    randomizeKeys: true,
  );

  // Contrôleurs pour le format personnalisé (XX-XXXX)
  final TextEditingController _refController = TextEditingController();
  final SecretKeyboardController _refKeyboardController = SecretKeyboardController(
    maxLength: 7,  // 6 chiffres + 1 tiret
    randomizeKeys: true,
  );

  // Contrôleurs pour le format sans zéro initial
  final TextEditingController _noZeroController = TextEditingController();
  final SecretKeyboardController _noZeroKeyboardController = SecretKeyboardController(
    maxLength: 5,
    randomizeKeys: true,
  );

  @override
  void dispose() {
    _pinController.dispose();
    _pinKeyboardController.dispose();
    _refController.dispose();
    _refKeyboardController.dispose();
    _noZeroController.dispose();
    _noZeroKeyboardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Titre explicatif
          const Text(
            'Formatage du texte saisi',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Démonstration des différents types de formatage.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Exemple 1: Code PIN standard
          const Text(
            '1. Code PIN (format standard)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Limite à 4 chiffres uniquement',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _pinController,
            decoration: const InputDecoration(
              labelText: 'Code PIN',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 8,
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),

          SecretKeyboard(
            controller: _pinKeyboardController,
            textController: _pinController,
            theme: SecretKeyboardTheme.material,
            style: const SecretKeyboardStyle(
              cellAspectRatio: 1.5,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(4),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onClick: (value) {
              // Action sur clic
            },
            onCodeCompleted: (code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Code PIN complété: $code')),
              );
            },
          ),
          const SizedBox(height: 32),

          // Exemple 2: Code de référence (XX-XXXX)
          const Text(
            '2. Code de référence (format XX-XXXX)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Formatter personnalisé pour formater automatiquement selon le modèle XX-XXXX',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _refController,
            decoration: const InputDecoration(
              labelText: 'Code de référence',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),

          SecretKeyboard(
            controller: _refKeyboardController,
            textController: _refController,
            theme: SecretKeyboardTheme.iOS,
            style: const SecretKeyboardStyle(
              cellAspectRatio: 1.5,
            ),
            inputFormatters: [
              _ReferenceCodeFormatter(),
            ],
            onClick: (value) {
              // Action sur clic
            },
            onCodeCompleted: (code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Code de référence complété: $code')),
              );
            },
          ),
          const SizedBox(height: 32),

          // Exemple 3: Code sans zéro initial
          const Text(
            '3. Code sans zéro initial',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Utilisation de PreventLeadingZeroFormatter pour empêcher le zéro au début',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _noZeroController,
            decoration: const InputDecoration(
              labelText: 'Code sans zéro initial',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: 16),

          SecretKeyboard(
            controller: _noZeroKeyboardController,
            textController: _noZeroController,
            theme: SecretKeyboardTheme.banking,
            style: const SecretKeyboardStyle(
              cellAspectRatio: 1.5,
            ),
            inputFormatters: [
              PreventLeadingZeroFormatter(),
              LengthLimitingTextInputFormatter(5),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onClick: (value) {
              // Action sur clic
            },
            onCodeCompleted: (code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Code sans zéro initial complété: $code')),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Page de démonstration des configurations de colonnes
class ColumnsDemoPage extends StatefulWidget {
  const ColumnsDemoPage({super.key});

  @override
  State<ColumnsDemoPage> createState() => _ColumnsDemoPageState();
}

class _ColumnsDemoPageState extends State<ColumnsDemoPage> {
  // Contrôleurs pour le clavier à 3 colonnes
  final TextEditingController _3colController = TextEditingController();
  late SecretKeyboardController _3colKeyboardController = SecretKeyboardController(
    gridColumns: 3,
    maxLength: 4,
    randomizeKeys: false,
  );

  // Contrôleurs pour le clavier à 4 colonnes
  final TextEditingController _4colController = TextEditingController();
  late SecretKeyboardController _4colKeyboardController = SecretKeyboardController(
    gridColumns: 4,
    maxLength: 4,
    randomizeKeys: false,
  );

  // Options pour l'affichage de la grille
  bool _showGrid = true;
  bool _showOuterBorder = true;
  bool _randomizeKeys = false;

  @override
  void dispose() {
    _3colController.dispose();
    _3colKeyboardController.dispose();
    _4colController.dispose();
    _4colKeyboardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Titre explicatif
          const Text(
            'Configurations de colonnes',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Comparaison entre les dispositions à 3 et 4 colonnes.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),

          // Options de configuration
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Options d\'affichage',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Option pour afficher la grille
                  SwitchListTile(
                    title: const Text('Afficher la grille'),
                    value: _showGrid,
                    onChanged: (value) {
                      setState(() {
                        _showGrid = value;
                      });
                    },
                  ),

                  // Option pour afficher la bordure externe
                  SwitchListTile(
                    title: const Text('Afficher la bordure externe'),
                    value: _showOuterBorder,
                    onChanged: (value) {
                      setState(() {
                        _showOuterBorder = value;
                      });
                    },
                  ),

                  // Option pour mélanger les touches
                  SwitchListTile(
                    title: const Text('Mélanger les touches'),
                    value: _randomizeKeys,
                    onChanged: (value) {
                      setState(() {
                        _randomizeKeys = value;

                        // Recréer les contrôleurs avec la nouvelle configuration
                        _3colKeyboardController.dispose();
                        _4colKeyboardController.dispose();

                        _3colController.clear();
                        _4colController.clear();

                        _3colKeyboardController = SecretKeyboardController(
                          gridColumns: 3,
                          maxLength: 4,
                          randomizeKeys: value,
                        );

                        _4colKeyboardController = SecretKeyboardController(
                          gridColumns: 4,
                          maxLength: 4,
                          randomizeKeys: value,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Clavier à 3 colonnes
          const Text(
            'Disposition à 3 colonnes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Style téléphonique traditionnel (1-9, puis 0)',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _3colController,
            decoration: const InputDecoration(
              labelText: 'Code (3 colonnes)',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: 16),

          // Clavier à 3 colonnes
          SecretKeyboard(
            controller: _3colKeyboardController,
            textController: _3colController,
            showGrid: _showGrid,
            style: SecretKeyboardStyle(
              cellAspectRatio: 1.25,
              showOuterBorder: _showOuterBorder,
              backgroundColor: Colors.white,
              showBorders: _showGrid, // Ajout pour gérer correctement les bordures
            ),
            onClick: (value) {
              // Action sur clic
            },
            onCodeCompleted: (code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Code complété (3 colonnes): $code')),
              );
            },
          ),
          const SizedBox(height: 32),

          // Clavier à 4 colonnes
          const Text(
            'Disposition à 4 colonnes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Disposition élargie (1-8, puis 9 et 0)',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _4colController,
            decoration: const InputDecoration(
              labelText: 'Code (4 colonnes)',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: 16),

          // Clavier à 4 colonnes
          SecretKeyboard(
            controller: _4colKeyboardController,
            textController: _4colController,
            showGrid: _showGrid,
            style: SecretKeyboardStyle(
              cellAspectRatio: 1.25,
              showOuterBorder: _showOuterBorder,
              backgroundColor: Colors.white,
              showBorders: _showGrid, // Ajout pour gérer correctement les bordures
            ),
            onClick: (value) {
              // Action sur clic
            },
            onCodeCompleted: (code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Code complété (4 colonnes): $code')),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Formatter personnalisé pour formater le texte selon le modèle XX-XXXX
class _ReferenceCodeFormatter extends TextInputFormatter {
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
