import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/screens/screens.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  static const name = 'verify-email-screen';
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(authProvider.notifier).sendEmailVerification(widget.email);
    });
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email;
    final verifyEmailForm = ref.watch(verifyEmailFormProvider(email));
    final verifyEmailFormNotifier = ref.read(
      verifyEmailFormProvider(email).notifier,
    );
    final authProviderNotifier = ref.read(authProvider.notifier);
    final emailText = email.isEmpty
        ? 'Ingresa el codigo de 6 digitos que enviamos a tu correo.'
        : 'Ingresa el codigo de 6 digitos que enviamos a $email.';

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      _showSnackbar(context, next.errorMessage);
    });

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
                    onChanged: verifyEmailFormNotifier.onCodeChanged,
                    errorMessage: verifyEmailForm.isFormPosted
                        ? verifyEmailForm.code.errorMessage
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      final sent = await authProviderNotifier
                          .sendEmailVerification(email);
                      if (sent && mounted) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Codigo de verificacion reenviado'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: const Text('Reenviar codigo'),
                  ),
                  const SizedBox(height: 24),
                  LoadingFloatingActionButton(
                    label: "Verificar",
                    loader: verifyEmailForm.isPosting,
                    onPressed: () async {
                      final verified = await verifyEmailFormNotifier
                          .onFormSubmit();
                      if (!mounted || !verified) return;
                      // ignore: use_build_context_synchronously
                      context.goNamed(SuccesfulSignupScreen.name);
                    },
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
