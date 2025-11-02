import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_route_app/presentation/screens/signup/succesful_signup_screen.dart';

class SignupScreen extends StatelessWidget {
  static const name = 'signup-screen';

  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: SizedBox()),
              const Text(
                "Registrate",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Expanded(child: SizedBox()),
              Form(
                child: Column(
                  spacing: 5,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nombre'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Apellido'),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Contraseña'),
                      obscureText: true,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirmar Contraseña',
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  context.goNamed(SuccesfulSignupScreen.name);
                },
                label: const Text("Registrarse"),
                elevation: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
