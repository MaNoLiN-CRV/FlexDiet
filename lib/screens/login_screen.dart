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
      backgroundColor: const Color(0xFFE3EDF7), // Background Color
      body: Center(
        // Center the content vertically and horizontally
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Keep items centered
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'FlexDiet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36, // Larger title
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF30436E), // Text Color
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tu camino hacia una vida saludable',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, // Slightly larger subtitle
                  color: const Color(0xFF30436E), // Text Color
                  fontWeight: FontWeight.w400, // Lighter weight
                ),
              ),
              const SizedBox(height: 50), // Increased space
              // Username Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // White container for input fields
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05), // Subtle shadow
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    labelStyle: const TextStyle(color: Color(0xFF30436E)),
                    border: InputBorder.none, // Remove the default border
                    prefixIcon: const Icon(Icons.person_outline,
                        color: Color(0xFF30436E)), // Outlined person icon
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Password Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: const TextStyle(color: Color(0xFF30436E)),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: Color(0xFF30436E)), // Outlined lock icon
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

              // Login Button
              ElevatedButton(
                onPressed: () {
                  // Handle login logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5451D6), // Button Color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Comenzar mi viaje saludable',
                  style: TextStyle(color: Colors.white), // Text Color
                ),
              ),

              const SizedBox(height: 10),

              // Forgot Password & Sign Up (Vertical)
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Align items to the center
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: Color(0xFF4530B3), // Text Color
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Únete ahora',
                      style: TextStyle(
                        color: Color(0xFF4530B3), // Text Color
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              //Divider
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

              //Social Buttons

              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: GoogleAuthButton(
                      onPressed: () {},
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

              // Fingerprint Auth
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
}
