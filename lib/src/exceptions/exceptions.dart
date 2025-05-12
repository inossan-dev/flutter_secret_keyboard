/// Exception de base pour tous les problèmes liés au clavier secret
class SecretKeyboardException implements Exception {
  final String message;

  const SecretKeyboardException(this.message);

  @override
  String toString() => 'SecretKeyboardException: $message';
}

/// Exception pour les paramètres invalides
class InvalidParameterException extends SecretKeyboardException {
  final String parameterName;
  final dynamic value;
  final String? expectedValue;

  InvalidParameterException({
    required this.parameterName,
    required this.value,
    this.expectedValue,
  }) : super(_buildMessage(parameterName, value, expectedValue));

  static String _buildMessage(String parameterName, dynamic value, String? expectedValue) {
    final expected = expectedValue != null ? ' Expected: $expectedValue.' : '';
    return 'Invalid value for parameter "$parameterName": $value.$expected';
  }
}