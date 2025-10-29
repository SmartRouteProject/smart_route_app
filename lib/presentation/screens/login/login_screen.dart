import 'package:flutter/material.dart';

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
                FloatingActionButton.extended(
                  onPressed: () {},
                  label: const Text("Iniciar sesión con Google"),
                  icon: const Icon(Icons.login),
                  elevation: 0,
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
