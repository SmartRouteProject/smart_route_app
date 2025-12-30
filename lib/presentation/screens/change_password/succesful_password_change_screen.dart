import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'package:smart_route_app/presentation/screens/screens.dart';

class SuccesfulPasswordChangeScreen extends StatelessWidget {
  static const name = 'succesfull-password-change-screen';

  const SuccesfulPasswordChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(child: SizedBox()),
              Lottie.asset(
                "assets/animations/success_check.json",
                repeat: false,
              ),
              const Text(
                "Contraseña actualizada con exito",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Expanded(child: SizedBox()),
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  context.goNamed(LoginScreen.name);
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
