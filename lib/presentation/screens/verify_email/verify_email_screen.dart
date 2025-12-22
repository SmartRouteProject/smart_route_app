import 'package:flutter/material.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class VerifyEmailScreen extends StatelessWidget {
  static const name = 'verify-email-screen';

  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifica tu correo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Ingresa el codigo de 6 digitos que enviamos a tu correo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 28),
                  OneTimePasswordInput(
                    onChanged: (value) => debugPrint("ONTimePassword: $value"),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Reenviar codigo'),
                  ),
                  const SizedBox(height: 24),
                  LoadingFloatingActionButton(
                    label: "Verificar",
                    loader: false,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
