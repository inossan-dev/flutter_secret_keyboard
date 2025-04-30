import 'package:flutter/material.dart';
import 'package:flutter_secret_keyboard/flutter_secret_keyboard.dart';

class DualInputExample extends StatefulWidget {
  const DualInputExample({super.key});

  @override
  State<DualInputExample> createState() => _DualInputExampleState();
}

class _DualInputExampleState extends State<DualInputExample> {
  late SecretKeyboardController _controller;
  final TextEditingController _textController = TextEditingController();
  late SecretKeyboardTextFieldBinding _binding;
  String _message = '';
  final FocusNode _focusNode = FocusNode();
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _controller = SecretKeyboardController(
      fingerprintEnabled: true,
      maxLength: 4,
      randomizeKeys: true,
    );

    // Créer la liaison entre le TextField et le clavier secret
    _binding = SecretKeyboardTextFieldBinding(
      keyboardController: _controller,
      textEditingController: _textController,
      obscureText: false, // Affichage visible pour cet exemple
    );

    // Écouter les modifications du TextField pour les synchroniser avec le clavier
    _textController.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    // Éviter les boucles infinies en vérifiant si nous sommes déjà en train de synchroniser
    if (!_isSyncing && _focusNode.hasFocus) {
      setState(() {
        _isSyncing = true;
        //_binding.syncFromTextField();
        _isSyncing = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_handleTextChange);
    _controller.dispose();
    _textController.dispose();
    _binding.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemple de saisie double'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Entrez votre code PIN (via le clavier ou directement dans le champ)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // TextField modifiable directement
            TextField(
              controller: _textController,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Code PIN',
                counterText: '', // Masquer le compteur de caractères
              ),
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
            ),

            const SizedBox(height: 20),

            // Affichage des indicateurs visuels pour montrer la synchronisation
            SecretCodeIndicator(
              controller: _controller,
              horizontalPadding: 80,
              indicatorSize: 25,
              activeColor: Colors.blue,
            ),

            const SizedBox(height: 20),

            Text(
              _message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),

            const Spacer(),

            // Clavier secret
            SecretKeyboard(
              cellAspectRatio: 1.2,
              controller: _controller,
              showSecretCode: false,
              showGrid: false,
              onClick: (code) {
                // Le TextField est automatiquement mis à jour par la liaison
                setState(() {
                  _message = 'Code en cours de saisie: $code';
                });
              },
              onCodeCompleted: (code) {
                setState(() {
                  _message = 'Code complet: $code';
                });
              },
              height: 300,
              deleteButtonWidget: const Icon(Icons.backspace, color: Colors.red),
              fingerprintButtonWidget: const Icon(Icons.fingerprint, color: Colors.blue),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
