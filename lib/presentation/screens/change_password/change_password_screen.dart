import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class ChangePasswordScreen extends ConsumerWidget {
  static const name = 'change-password-screen';

  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(changePasswordFormProvider);
    final notifier = ref.read(changePasswordFormProvider.notifier);
    final isLastStep = form.currentStep == 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar contraseña'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: Stepper(
                    currentStep: form.currentStep,
                    onStepContinue: notifier.onStepContinue,
                    onStepCancel: notifier.onStepCancel,
                    onStepTapped: notifier.onStepTapped,
                    controlsBuilder: (context, details) {
                      return Row(
                        children: [
                          ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: Text(isLastStep ? 'Guardar' : 'Continuar'),
                          ),
                          const SizedBox(width: 12),
                          if (form.currentStep > 0)
                            TextButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Atras'),
                            ),
                        ],
                      );
                    },
                    steps: [
                      Step(
                        title: const Text('Correo'),
                        isActive: form.currentStep >= 0,
                        content: CustomTextFormField(
                          label: 'Correo electronico',
                          keyboardType: TextInputType.emailAddress,
                          onChanged: notifier.onEmailChange,
                          errorMessage: form.isFormPosted
                              ? form.email.errorMessage
                              : null,
                        ),
                      ),
                      Step(
                        title: const Text('Codigo'),
                        isActive: form.currentStep >= 1,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Ingresa el codigo de 6 digitos que enviamos a tu correo.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            OneTimePasswordInput(
                              onChanged: notifier.onCodeChange,
                            ),
                            if (form.isFormPosted &&
                                form.code.errorMessage != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                form.code.errorMessage!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Step(
                        title: const Text('Nueva contraseña'),
                        isActive: form.currentStep >= 2,
                        content: Column(
                          children: [
                            CustomTextFormField(
                              label: 'Contraseña',
                              isPassword: true,
                              onChanged: notifier.onPasswordChange,
                              errorMessage: form.isFormPosted
                                  ? form.password.errorMessage
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormField(
                              label: 'Confirmar contraseña',
                              isPassword: true,
                              onChanged: notifier.onConfirmPasswordChange,
                              errorMessage: form.isFormPosted
                                  ? form.confirmPassword.errorMessage
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
