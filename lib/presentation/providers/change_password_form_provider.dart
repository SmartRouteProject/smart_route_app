import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:smart_route_app/infrastructure/inputs/inputs.dart';
import 'package:smart_route_app/presentation/providers/auth_provider.dart';

final changePasswordFormProvider =
    StateNotifierProvider.autoDispose<
      ChangePasswordFormNotifier,
      ChangePasswordFormState
    >((ref) {
      return ChangePasswordFormNotifier(ref);
    });

class ChangePasswordFormNotifier
    extends StateNotifier<ChangePasswordFormState> {
  final Ref _ref;

  ChangePasswordFormNotifier(this._ref) : super(ChangePasswordFormState());

  void onEmailChange(String value) {
    final email = Email.dirty(value);
    state = state.copyWith(
      email: email,
      isValid: _validateAll(email: email),
    );
  }

  void onCodeChange(String value) {
    final code = OtpCode.dirty(value);
    state = state.copyWith(
      code: code,
      isValid: _validateAll(code: code),
    );
  }

  void onPasswordChange(String value) {
    final password = Password.dirty(value);
    final confirmPassword = ConfirmPassword.dirty(
      password: value,
      value: state.confirmPassword.value,
    );
    state = state.copyWith(
      password: password,
      confirmPassword: confirmPassword,
      isValid: _validateAll(
        password: password,
        confirmPassword: confirmPassword,
      ),
    );
  }

  void onConfirmPasswordChange(String value) {
    final confirmPassword = ConfirmPassword.dirty(
      password: state.password.value,
      value: value,
    );
    state = state.copyWith(
      confirmPassword: confirmPassword,
      isValid: _validateAll(confirmPassword: confirmPassword),
    );
  }

  void onStepTapped(int index) {
    state = state.copyWith(currentStep: index);
  }

  Future<void> onStepContinue() async {
    if (state.currentStep == 0) {
      final email = Email.dirty(state.email.value);
      final isStepValid = Formz.validate([email]);
      state = state.copyWith(
        isFormPosted: true,
        email: email,
        isValid: _validateAll(email: email),
      );
      if (!isStepValid) return;
      final sent = await _requestPasswordChange(email.value);
      if (!sent) return;
      state = state.copyWith(currentStep: 1, isFormPosted: false);
      return;
    }

    if (state.currentStep == 1) {
      final code = OtpCode.dirty(state.code.value);
      final isStepValid = Formz.validate([code]);
      state = state.copyWith(
        isFormPosted: true,
        code: code,
        isValid: _validateAll(code: code),
      );
      if (!isStepValid) return;
      state = state.copyWith(currentStep: 2);
      return;
    }

    if (state.currentStep == 2) {
      await onSubmit();
    }
  }

  void onStepCancel() {
    if (state.currentStep == 0) return;
    state = state.copyWith(currentStep: state.currentStep - 1);
  }

  bool _validateAll({
    Email? email,
    OtpCode? code,
    Password? password,
    ConfirmPassword? confirmPassword,
  }) {
    return Formz.validate([
      email ?? state.email,
      code ?? state.code,
      password ?? state.password,
      confirmPassword ?? state.confirmPassword,
    ]);
  }

  Future<void> onResendCode() async {
    final email = Email.dirty(state.email.value);
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      isValid: _validateAll(email: email),
    );
    final isStepValid = Formz.validate([email]);
    if (!isStepValid) return;
    await _requestPasswordChange(email.value);
  }

  Future<bool> onSubmit() async {
    final password = Password.dirty(state.password.value);
    final confirmPassword = ConfirmPassword.dirty(
      password: password.value,
      value: state.confirmPassword.value,
    );
    final isStepValid = Formz.validate([password, confirmPassword]);
    state = state.copyWith(
      isFormPosted: true,
      password: password,
      confirmPassword: confirmPassword,
      isValid: _validateAll(
        password: password,
        confirmPassword: confirmPassword,
      ),
    );
    if (!isStepValid) return false;

    if (state.isPosting) return false;
    state = state.copyWith(isPosting: true, errorMessage: '');
    try {
      final verified = await _ref
          .read(authProvider.notifier)
          .verifyPasswordChange(
            state.email.value,
            state.code.value,
            password.value,
          );
      if (!verified) {
        state = state.copyWith(
          isPosting: false,
          errorMessage: 'No se pudo actualizar la contrasena',
        );
        return false;
      }
      state = state.copyWith(isPosting: false, errorMessage: '');
      return true;
    } on ArgumentError catch (err) {
      state = state.copyWith(isPosting: false, errorMessage: err.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isPosting: false,
        errorMessage: 'No se pudo actualizar la contrasena',
      );
      return false;
    }
  }

  Future<bool> _requestPasswordChange(String email) async {
    if (state.isPosting) return false;
    state = state.copyWith(isPosting: true, errorMessage: '');
    try {
      final sent = await _ref
          .read(authProvider.notifier)
          .requestPasswordChange(email);
      if (!sent) {
        state = state.copyWith(
          isPosting: false,
          errorMessage: 'No se pudo solicitar el cambio de contrasena',
        );
        return false;
      }
      state = state.copyWith(isPosting: false, errorMessage: '');
      return true;
    } on ArgumentError catch (err) {
      state = state.copyWith(isPosting: false, errorMessage: err.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isPosting: false,
        errorMessage: 'No se pudo solicitar el cambio de contrasena',
      );
      return false;
    }
  }

  void clearError() {
    if (state.errorMessage.isEmpty) return;
    state = state.copyWith(errorMessage: '');
  }
}

class ChangePasswordFormState {
  final int currentStep;
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final OtpCode code;
  final Password password;
  final ConfirmPassword confirmPassword;
  final String errorMessage;

  ChangePasswordFormState({
    this.currentStep = 0,
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.code = const OtpCode.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.errorMessage = '',
  });

  ChangePasswordFormState copyWith({
    int? currentStep,
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    OtpCode? code,
    Password? password,
    ConfirmPassword? confirmPassword,
    String? errorMessage,
  }) => ChangePasswordFormState(
    currentStep: currentStep ?? this.currentStep,
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    code: code ?? this.code,
    password: password ?? this.password,
    confirmPassword: confirmPassword ?? this.confirmPassword,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
