import 'package:flutter/material.dart';

import 'package:smart_route_app/presentation/widgets/widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const name = 'change-password-screen';

  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  int _currentStep = 0;
  String _email = '';
  String _code = '';
  String _password = '';
  String _confirmPassword = '';

  void _handleContinue() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Contraseña actualizada')));
  }

  void _handleCancel() {
    if (_currentStep == 0) return;
    setState(() {
      _currentStep -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar contraseña'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: _handleContinue,
              onStepCancel: _handleCancel,
              onStepTapped: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              controlsBuilder: (context, details) {
                final isLastStep = _currentStep == 2;
                return Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(isLastStep ? 'Guardar' : 'Continuar'),
                    ),
                    const SizedBox(width: 12),
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Atrás'),
                      ),
                  ],
                );
              },
              steps: [
                Step(
                  title: const Text('Correo'),
                  isActive: _currentStep >= 0,
                  content: CustomTextFormField(
                    label: 'Correo electronico',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => _email = value,
                  ),
                ),
                Step(
                  title: const Text('Codigo'),
                  isActive: _currentStep >= 1,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Ingresa el codigo de 6 digitos que enviamos a tu correo.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      OneTimePasswordInput(onChanged: (value) => _code = value),
                    ],
                  ),
                ),
                Step(
                  title: const Text('Nueva contraseña'),
                  isActive: _currentStep >= 2,
                  content: Column(
                    children: [
                      CustomTextFormField(
                        label: 'Contraseña',
                        isPassword: true,
                        onChanged: (value) => _password = value,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        label: 'Confirmar contraseña',
                        isPassword: true,
                        onChanged: (value) => _confirmPassword = value,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
