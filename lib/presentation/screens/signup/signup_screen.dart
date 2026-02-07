import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_route_app/presentation/screens/screens.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

import '../../providers/providers.dart';

class SignupScreen extends StatelessWidget {
  static const name = 'signup-screen';

  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: size.height * 0.3,
                    child: Center(
                      child: const Text(
                        "Registrate",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  Expanded(child: _SignupForm()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends ConsumerWidget {
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
    final signupForm = ref.watch(signupFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Form(
          child: Column(
            spacing: 5,
            children: [
              CustomTextFormField(
                label: 'Nombre',
                onChanged: ref
                    .read(signupFormProvider.notifier)
                    .onUserNameChange,
                errorMessage: signupForm.isFormPosted
                    ? signupForm.userName.errorMessage
                    : null,
              ),
              CustomTextFormField(
                label: 'Apellido',
                onChanged: ref
                    .read(signupFormProvider.notifier)
                    .onUserLastnameChange,
                errorMessage: signupForm.isFormPosted
                    ? signupForm.userLastName.errorMessage
                    : null,
              ),
              CustomTextFormField(
                label: 'Correo electrónico',
                onChanged: ref.read(signupFormProvider.notifier).onEmailChange,
                errorMessage: signupForm.isFormPosted
                    ? signupForm.email.errorMessage
                    : null,
              ),
              CustomTextFormField(
                label: 'Contraseña',
                onChanged: ref
                    .read(signupFormProvider.notifier)
                    .onPasswordChange,
                isPassword: true,
                errorMessage: signupForm.isFormPosted
                    ? signupForm.password.errorMessage
                    : null,
              ),
              CustomTextFormField(
                label: 'Confirmar Contraseña',
                isPassword: true,
                onChanged: ref
                    .read(signupFormProvider.notifier)
                    .onConfirmPasswordChange,
                errorMessage: signupForm.isFormPosted
                    ? signupForm.confirmPassword.errorMessage
                    : null,
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        LoadingFloatingActionButton(
          label: 'Registrarse',
          loader: signupForm.isPosting,
          onPressed: () async {
            final isValidForm = await ref
                .read(signupFormProvider.notifier)
                .onFormSubmit();
            if (isValidForm) {
              // ignore: use_build_context_synchronously
              context.goNamed(
                VerifyEmailScreen.name,
                queryParameters: {'email': signupForm.email.value},
              );
            }
          },
        ),
      ],
    );
  }
}
