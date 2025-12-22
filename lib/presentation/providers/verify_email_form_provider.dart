import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:smart_route_app/infrastructure/inputs/inputs.dart';

final verifyEmailFormProvider = StateNotifierProvider.autoDispose.family<
    VerifyEmailFormNotifier, VerifyEmailFormState, String>((ref, email) {
  return VerifyEmailFormNotifier(email: email);
});

class VerifyEmailFormNotifier extends StateNotifier<VerifyEmailFormState> {
  VerifyEmailFormNotifier({required String email})
    : super(VerifyEmailFormState(email: email));

  void onCodeChanged(String value) {
    final newCode = OtpCode.dirty(value);
    state = state.copyWith(code: newCode, isValid: Formz.validate([newCode]));
  }

  Future<bool> onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return false;

    state = state.copyWith(isPosting: true);
    state = state.copyWith(isPosting: false);
    return true;
  }

  void _touchEveryField() {
    final code = OtpCode.dirty(state.code.value);
    state = state.copyWith(
      isFormPosted: true,
      code: code,
      isValid: Formz.validate([code]),
    );
  }
}

class VerifyEmailFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final OtpCode code;
  final String email;

  VerifyEmailFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.code = const OtpCode.pure(),
    required this.email,
  });

  VerifyEmailFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    OtpCode? code,
    String? email,
  }) => VerifyEmailFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    code: code ?? this.code,
    email: email ?? this.email,
  );
}
