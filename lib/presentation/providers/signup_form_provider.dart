import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:smart_route_app/domain/domain.dart';

import 'package:smart_route_app/infrastructure/inputs/inputs.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';

final signupFormProvider =
    StateNotifierProvider.autoDispose<SignupFormNotifier, SignupFormState>((
      ref,
    ) {
      Future<void> signupUserCallback(User user) =>
          ref.watch(authProvider.notifier).registerUser(user);

      return SignupFormNotifier(signupUserCallback: signupUserCallback);
    });

class SignupFormNotifier extends StateNotifier<SignupFormState> {
  final Function(User) signupUserCallback;

  SignupFormNotifier({required this.signupUserCallback})
    : super(SignupFormState());

  Future<bool> onFormSubmit() async {
    try {
      _touchEveryField();

      if (!state.isValid) return false;

      final newUser = User.fromSignupForm(state);

      state = state.copyWith(isPosting: true);

      await signupUserCallback(newUser);

      state = state.copyWith(isPosting: false);

      return true;
    } catch (err) {
      state = state.copyWith(isPosting: false);
      return false;
    }
  }

  onUserNameChange(String value) {
    final newUserName = UserName.dirty(value);
    state = state.copyWith(
      userName: newUserName,
      isValid: Formz.validate([
        newUserName,
        state.userLastName,
        state.email,
        state.password,
        state.confirmPassword,
      ]),
    );
  }

  onUserLastnameChange(String value) {
    final newUserLastname = UserName.dirty(value);
    state = state.copyWith(
      userLastName: newUserLastname,
      isValid: Formz.validate([
        state.userName,
        newUserLastname,
        state.email,
        state.password,
        state.confirmPassword,
      ]),
    );
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([
        state.userName,
        state.userLastName,
        newEmail,
        state.password,
        state.confirmPassword,
      ]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([
        state.userName,
        state.userLastName,
        state.email,
        newPassword,
        state.confirmPassword,
      ]),
    );
  }

  onConfirmPasswordChange(String value) {
    final newConfirmPassword = ConfirmPassword.dirty(
      value: value,
      password: state.password.value,
    );
    state = state.copyWith(
      confirmPassword: newConfirmPassword,
      isValid: Formz.validate([
        state.userName,
        state.userLastName,
        state.email,
        state.password,
        newConfirmPassword,
      ]),
    );
  }

  _touchEveryField() {
    final userName = UserName.dirty(state.userName.value);
    final userLastname = UserName.dirty(state.userLastName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = ConfirmPassword.dirty(
      value: state.confirmPassword.value,
      password: password.value,
    );

    state = state.copyWith(
      isFormPosted: true,
      userName: userName,
      userLastName: userLastname,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      isValid: Formz.validate([
        userName,
        userLastname,
        email,
        password,
        confirmPassword,
      ]),
    );
  }
}

class SignupFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final UserName userName;
  final UserName userLastName;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;

  SignupFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.userName = const UserName.pure(),
    this.userLastName = const UserName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
  });

  SignupFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    UserName? userName,
    UserName? userLastName,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
  }) => SignupFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    userName: userName ?? this.userName,
    userLastName: userLastName ?? this.userLastName,
    email: email ?? this.email,
    password: password ?? this.password,
    confirmPassword: confirmPassword ?? this.confirmPassword,
  );
}
