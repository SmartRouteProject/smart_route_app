import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class VerifyEmailScreen extends ConsumerWidget {
  static const name = 'verify-email-screen';
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(verifyEmailFormProvider(email));
    final notifier = ref.read(verifyEmailFormProvider(email).notifier);
    final emailText = email.isEmpty
        ? 'Ingresa el codigo de 6 digitos que enviamos a tu correo.'
        : 'Ingresa el codigo de 6 digitos que enviamos a $email.';

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
                  Text(
                    emailText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 28),
                  OneTimePasswordInput(
                    onChanged: notifier.onCodeChanged,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Reenviar codigo'),
                  ),
                  const SizedBox(height: 24),
                  LoadingFloatingActionButton(
                    label: "Verificar",
                    loader: form.isPosting,
                    onPressed: () => notifier.onFormSubmit(),
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
