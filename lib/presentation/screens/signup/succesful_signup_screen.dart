import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SuccesfulSignupScreen extends StatelessWidget {
  static const name = 'succesfull-signup-screen';

  const SuccesfulSignupScreen({super.key});

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
              Lottie.asset(
                "assets/animations/success_check.json",
                repeat: false,
              ),
              const Text(
                "Usuario registrado con exito",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Expanded(child: SizedBox()),
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  context.go("/login");
                },
                label: const Text("Iniciar Sesion"),
                elevation: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
