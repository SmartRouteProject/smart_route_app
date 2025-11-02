import 'package:flutter/material.dart';
import 'package:smart_route_app/config/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  static const name = 'login-screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: SizedBox()),
                const Text(
                  "Inicia Sesión",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Expanded(child: SizedBox()),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Contraseña'),
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                FloatingActionButton.extended(
                  onPressed: () {},
                  label: const Text("Ingresar"),
                  elevation: 0,
                ),
                const SizedBox(height: 16),
                const Text("O", textAlign: TextAlign.center),
                const SizedBox(height: 16),
                GoogleSignInButton(),
                Expanded(child: SizedBox()),
                Text("¿No tienes una cuenta?", textAlign: TextAlign.center),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  onPressed: () {},
                  label: const Text("Registrate"),
                  elevation: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoogleSignInButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Image.asset('assets/images/google_logo.png', height: 24),
      label: const Text(
        'Iniciar sesión con Google',
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: Colors.white,
      ),
      onPressed: () {}, // <- sin lógica por ahora
    );
  }
}
