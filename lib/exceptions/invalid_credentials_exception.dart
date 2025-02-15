

class InvalidCredentialsException implements Exception {
  String _message;

  InvalidCredentialsException():
    _message = 'Debes introducir el correo electrónico y la contraseña';


}