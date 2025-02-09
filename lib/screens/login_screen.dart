import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3EDF7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'FlexDiet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF30436E),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tu camino hacia una vida saludable',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF30436E),
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(
                'Nombre de usuario',
                _usernameController,
                false,
                Icons.person,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                'Contraseña',
                _passwordController,
                true,
                Icons.lock,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5451D6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 8,
                  shadowColor: const Color(0xFF5451D6),
                ),
                onPressed: () {},
                child: const Text(
                  'Comenzar mi viaje saludable',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    color: Color(0xFF4530B3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '¿Nuevo en FlexDiet? Únete ahora',
                  style: TextStyle(
                    color: Color(0xFF4530B3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: const [
                  Expanded(
                    child: Divider(color: Color(0xFF30436E), thickness: 0.5),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'O continúa con',
                      style: TextStyle(color: Color(0xFF30436E)),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Color(0xFF30436E), thickness: 0.5),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Botones de autenticación en columna
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: GoogleAuthButton(
                      onPressed: () {},
                      themeMode: ThemeMode.dark,
                      style: const AuthButtonStyle(
                        buttonColor: Color(0xFF5451D6),
                        borderRadius: 12,
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: AppleAuthButton(
                      onPressed: () {},
                      themeMode: ThemeMode.dark,
                      style: const AuthButtonStyle(
                        buttonColor: Color(0xFF5451D6),
                        borderRadius: 12,
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.fingerprint,
                    size: 40,
                    color: Color(0xFF30436E),
                  ),
                  onPressed: () async {
                    bool canAuthenticate =
                        await _localAuth.canCheckBiometrics ||
                            await _localAuth.isDeviceSupported();
                    if (canAuthenticate) {
                      try {
                        await _localAuth.authenticate(
                          localizedReason: 'Autentícate para iniciar sesión',
                          options:
                              const AuthenticationOptions(biometricOnly: true),
                        );
                      } on PlatformException catch (e) {
                        print('Error en autenticación: $e');
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isPassword,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5451D6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        style: const TextStyle(color: Color(0xFF30436E)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF30436E)),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: const Color(0xFF5451D6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color(0xFF5451D6),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
