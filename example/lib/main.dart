// Fichier: example/lib/main.dart

import 'package:example/dual_input_example.dart';
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
  final TextEditingController _pinController = TextEditingController();
  final SecretKeyboardController _pinKeyboardController = SecretKeyboardController();

  final TextEditingController _formatController = TextEditingController();
  final SecretKeyboardController _formatKeyboardController = SecretKeyboardController();

  @override
  void dispose() {
    _pinController.dispose();
    _pinKeyboardController.dispose();
    _formatController.dispose();
    _formatKeyboardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SecretKeyboard avec inputFormatters'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TextField pour afficher le code PIN
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'Code PIN (limité à 4 chiffres)',
                border: OutlineInputBorder(),
              ),
              readOnly: true, // Lecture seule, modifié par le clavier
              obscureText: true,
            ),

            const SizedBox(height: 16),

            // Clavier secret avec limite de 4 chiffres
            SecretKeyboard(
              controller: _pinKeyboardController,
              onClick: (value) {
                // Action sur clic (optionnel)
              },
              onCodeCompleted: (code) {
                // Action lorsque le code est complet
                print('Code PIN complété: $code');
              },
              textController: _pinController,
              codeLength: 4,
              inputFormatters: [
                // Limite la longueur à 4 caractères
                LengthLimitingTextInputFormatter(4),
                // Accepte uniquement les chiffres
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),

            const SizedBox(height: 32),

            // TextField pour afficher le code formaté
            TextField(
              controller: _formatController,
              decoration: const InputDecoration(
                labelText: 'Code de référence (format XX-XXXX)',
                border: OutlineInputBorder(),
              ),
              readOnly: true, // Lecture seule, modifié par le clavier
            ),

            const SizedBox(height: 16),

            // Clavier secret avec formatter personnalisé
            SecretKeyboard(
              controller: _formatKeyboardController,
              onClick: (value) {
                // Action sur clic (optionnel)
              },
              textController: _formatController,
              codeLength: 7, // 7 caractères incluant le tiret
              inputFormatters: [
                // Formate automatiquement l'entrée selon le modèle XX-XXXX
                _ReferenceCodeFormatter(),
              ],
            ),
          ],
        ),
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