import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_route_app/presentation/screens/signup/succesful_signup_screen.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

import '../../providers/providers.dart';

class SignupScreen extends StatelessWidget {
  static const name = 'signup-screen';

  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Expanded(child: _SignupForm()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupForm = ref.watch(signupFormProvider);

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
                obscureText: true,
                errorMessage: signupForm.isFormPosted
                    ? signupForm.password.errorMessage
                    : null,
              ),
              CustomTextFormField(
                label: 'Confirmar Contraseña',
                obscureText: true,
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

        FloatingActionButton.extended(
          heroTag: null,
          onPressed: () async {
            final isValidForm = await ref
                .read(signupFormProvider.notifier)
                .onFormSubmit();
            // ignore: use_build_context_synchronously
            if (isValidForm) context.goNamed(SuccesfulSignupScreen.name);
          },
          label: const Text("Registrarse"),
          elevation: 0,
        ),
      ],
    );
  }
}
