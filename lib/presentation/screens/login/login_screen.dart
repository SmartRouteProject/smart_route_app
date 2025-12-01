import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/screens/screens.dart';
import 'package:smart_route_app/presentation/widgets/shared/custom_text_form_field.dart';

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

                _LoginForm(),

                const SizedBox(height: 16),
                const Text("O", textAlign: TextAlign.center),
                const SizedBox(height: 16),

                GoogleSignInButton(),

                Expanded(child: SizedBox()),

                Text("¿No tienes una cuenta?", textAlign: TextAlign.center),

                const SizedBox(height: 10),

                FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    context.pushNamed(SignupScreen.name);
                  },
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

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          child: Column(
            children: [
              CustomTextFormField(
                keyboardType: TextInputType.emailAddress,
                label: 'Correo electrónico',
                onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
                errorMessage: loginForm.isFormPosted
                    ? loginForm.email.errorMessage
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                label: 'Contraseña',
                obscureText: true,
                onChanged: ref
                    .read(loginFormProvider.notifier)
                    .onPasswordChanged,
                errorMessage: loginForm.isFormPosted
                    ? loginForm.password.errorMessage
                    : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FloatingActionButton.extended(
          heroTag: null,
          onPressed: () async {
            final loginResp = await ref
                .read(loginFormProvider.notifier)
                .onFormSubmit();
            if (loginResp) context.goNamed(HomeScreen.name);
          },
          label: const Text("Ingresar"),
          elevation: 0,
        ),
      ],
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
