import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flexdiet/screens/HomeScreen.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/widgets/CustomInputText.dart';
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            opacity: 0.8,
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'FlexDiet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF30436E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tu camino hacia una vida saludable',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xFF30436E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CustomInput(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de usuario',
                      labelStyle: const TextStyle(color: Color(0xFF30436E)),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.person_outline,
                          color: Color(0xFF30436E)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CustomInput(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(color: Color(0xFF30436E)),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: Color(0xFF30436E)),
                      suffixIcon: IconButton(
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
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Handle login logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF30436E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Comenzar mi viaje saludable',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          color: Color(0xFF30436E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Únete ahora',
                        style: TextStyle(
                          color: Color(0xFF30436E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                Column(
                  children: [
                    SizedBox(
                      width: 250,
                      child: GoogleAuthButton(
                        onPressed: () {},
                        style: const AuthButtonStyle(
                            buttonColor: Color(0xFF30436E),
                            borderRadius: 12,
                            textStyle:
                                TextStyle(fontSize: 16, color: Colors.white),
                            iconSize: 20),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 250,
                      child: AppleAuthButton(
                        onPressed: () {},
                        style: const AuthButtonStyle(
                            buttonColor: Color(0xFF30436E),
                            borderRadius: 12,
                            textStyle:
                                TextStyle(fontSize: 16, color: Colors.white),
                            iconSize: 20),
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
                            options: const AuthenticationOptions(
                                biometricOnly: true),
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
      ),
    );
  }
}
