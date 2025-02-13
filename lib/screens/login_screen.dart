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
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            opacity: 0.8,
            filterQuality: FilterQuality.high,
            colorFilter:  ColorFilter.mode(Color.fromARGB(115, 141, 141, 141), BlendMode.dstOver),
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
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme
                        .onSurface, 
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tu camino hacia una vida saludable',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme
                        .onSurface, 
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
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
                      labelStyle: theme.inputDecorationTheme.labelStyle?.copyWith(
                          color: theme.colorScheme
                              .onSurface), 
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person_outline,
                          color: theme.colorScheme
                              .onSurface), 
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
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
                      labelStyle: theme.inputDecorationTheme.labelStyle?.copyWith(
                          color: theme.colorScheme
                              .onSurface), 
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.lock_outline,
                          color: theme.colorScheme
                              .onSurface), 
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: theme.colorScheme.secondary,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  style: theme.elevatedButtonTheme.style,
                  child: Text('Comenzar mi viaje saludable',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      )),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme
                              .onSurface, 
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
                      child: Text(
                        'Únete ahora',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme
                              .onSurface, 
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                          color: theme.colorScheme.onSurface,
                          thickness:
                              0.5), 
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'O continúa con',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme
                                .onSurface), 
                      ),
                    ),
                    Expanded(
                      child: Divider(
                          color: theme.colorScheme.onSurface,
                          thickness:
                              0.5), 
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
                        style: AuthButtonStyle(
                            buttonColor: theme.colorScheme.surface,
                            borderRadius: 12,
                            textStyle: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 16,
                                color: theme.colorScheme.onSurface),
                            iconSize: 20),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 250,
                      child: AppleAuthButton(
                        onPressed: () {},
                        style: AuthButtonStyle(
                            buttonColor: theme.colorScheme.surface,
                            borderRadius: 12,
                            textStyle: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 16,
                                color: theme.colorScheme.onSurface),
                            iconSize: 20,
                            iconColor: theme.colorScheme.onSurface,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.fingerprint,
                      size: 40,
                      color: theme.colorScheme
                          .onSurface, // Use onSurface for better readability
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
