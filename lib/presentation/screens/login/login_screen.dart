// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/screens/screens.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

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
                  "Inicia Sesion",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                Expanded(child: SizedBox()),

                _LoginForm(),

                const SizedBox(height: 16),
                const Text("O", textAlign: TextAlign.center),
                const SizedBox(height: 16),

                const GoogleSignInButton(),

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
    final loginNotifier = ref.watch(loginFormProvider.notifier);

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
                label: 'Correo electronico',
                onChanged: loginNotifier.onEmailChange,
                errorMessage: loginForm.isFormPosted
                    ? loginForm.email.errorMessage
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                label: 'Contraseña',
                isPassword: true,
                onChanged: loginNotifier.onPasswordChanged,
                errorMessage: loginForm.isFormPosted
                    ? loginForm.password.errorMessage
                    : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        LoadingFloatingActionButton(
          label: 'Ingresar',
          loader: loginForm.isPosting,
          onPressed: () async {
            final loginResp = await ref
                .read(loginFormProvider.notifier)
                .onFormSubmit();
            if (!loginResp) return;

            final user = ref.read(authProvider).user;
            if (user != null && !user.validated) {
              context.goNamed(
                VerifyEmailScreen.name,
                queryParameters: {'email': user.email},
              );
              return;
            }

            context.goNamed(HomeScreen.name);
          },
        ),
      ],
    );
  }
}

class GoogleSignInButton extends ConsumerWidget {
  final Future<void> Function()? onPressed;

  const GoogleSignInButton({super.key, this.onPressed});

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
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleGoogleAuth() async {
      try {
        final googleSignIn = GoogleSignIn(
          serverClientId:
              "1029869450394-1qvguaclf8dds0o6s73kn651gop1rqcn.apps.googleusercontent.com",
        );
        final account = await googleSignIn.signIn();

        if (account == null) return;

        final authentication = await account.authentication;
        final idToken = authentication.idToken;

        if (idToken == null || idToken.isEmpty) {
          _showSnackbar(context, "No se pudo obtener el token de Google");
          return;
        }

        final success = await ref
            .read(authProvider.notifier)
            .loginWithGoogle(idToken);

        if (success) {
          final user = ref.read(authProvider).user;
          if (user != null && !user.validated) {
            context.goNamed(
              VerifyEmailScreen.name,
              queryParameters: {'email': user.email},
            );
            return;
          }
          context.goNamed(HomeScreen.name);
        } else {
          final errorMsg = ref.read(authProvider).errorMessage;
          if (errorMsg.isNotEmpty) _showSnackbar(context, errorMsg);
        }
      } catch (err) {
        _showSnackbar(context, "Ocurrio un error al iniciar sesion con Google");
      }
    }

    return OutlinedButton.icon(
      icon: Image.asset('assets/images/google_logo.png', height: 24),
      label: const Text(
        'Iniciar sesion con Google',
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: Colors.white,
      ),
      onPressed: onPressed ?? handleGoogleAuth,
    );
  }
}
