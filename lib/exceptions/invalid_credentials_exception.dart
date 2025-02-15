

class InvalidCredentialsException implements Exception {
  final String _message;

  InvalidCredentialsException():
    _message = 'Debes introducir el correo electrónico y la contraseña';

  get getMessage => _message;

}