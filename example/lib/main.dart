// Fichier: example/lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemple de Clavier Secret',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SecretKeyboardDemo(),
      //home: const DualInputExample(),
    );
  }
}

class SecretKeyboardDemo extends StatefulWidget {
  const SecretKeyboardDemo({super.key});

  @override
  State<SecretKeyboardDemo> createState() => _SecretKeyboardDemoState();
}

class _SecretKeyboardDemoState extends State<SecretKeyboardDemo> {
  late SecretKeyboardController _controller;
  final TextEditingController _textControllerMasked = TextEditingController();
  final TextEditingController _textControllerVisible = TextEditingController();
  String _message = '';
  bool _randomizeKeys = true;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = SecretKeyboardController(
      fingerprintEnabled: true,
      maxLength: 4,
      randomizeKeys: _randomizeKeys,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _textControllerMasked.dispose();
    _textControllerVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Démo du Clavier Secret'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ajouter deux exemples de TextField, un masqué et un normal
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text("Code masqué", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _textControllerMasked,
                        readOnly: true,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Version masquée',
                        ),
                        style: const TextStyle(fontSize: 24, letterSpacing: 8),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      const Text("Code visible", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _textControllerVisible,
                        readOnly: true,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Version visible',
                        ),
                        style: const TextStyle(fontSize: 24, letterSpacing: 8),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              _message,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 20),

            // Option pour mélanger les touches
            SwitchListTile(
              title: const Text('Mélanger les touches'),
              subtitle: const Text('Active/désactive la disposition aléatoire des chiffres'),
              value: _randomizeKeys,
              onChanged: (value) {
                setState(() {
                  _randomizeKeys = value;
                  // Recréer le contrôleur avec la nouvelle option
                  _controller.dispose();
                  _initController();
                });
              },
            ),

            const SizedBox(height: 20),

            // Clavier secret avec liaison aux deux TextFields
            SecretKeyboard(
              controller: _controller,
              codeLength: 4,
              textController: _textControllerMasked, // Liaison avec le TextField masqué
              obscureText: true, // Masquer le texte pour ce TextField
              onClick: (code) {
                setState(() {
                  // Mettre à jour manuellement le TextField visible
                  _textControllerVisible.text = code;
                });
              },
              onCodeCompleted: (code) {
                setState(() {
                  _message = 'Code complet: $code';
                });
              },
              onFingerprintClick: (_) {
                setState(() {
                  _message = 'Authentification par empreinte digitale demandée';
                });
              },
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
              backgroundColor: Colors.grey[200],
              indicatorActiveColor: Colors.blue,
              cellStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _controller.resetSecretCode();
                setState(() {
                  _message = '';
                });
              },
              child: const Text('Réinitialiser'),
            ),
          ],
        ),
      ),
    );
  }
}