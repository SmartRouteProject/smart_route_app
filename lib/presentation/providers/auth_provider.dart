import 'package:dio_flow/dio_flow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository authRepository;

  AuthNotifier({required this.authRepository}) : super(AuthState());

  Future<void> loginUser(String email, String password) async {
    try {
      final logResp = await authRepository.login(email, password);

      await TokenManager.setTokens(
        accessToken: logResp.accessToken,
        refreshToken: logResp.refreshToken,
        expiry: DateTime.now().add(Duration(minutes: logResp.expiresIn)),
      );

      state = state.copyWith(
        user: logResp.user,
        authStatus: AuthStatus.authenticated,
        errorMessage: '',
      );
    } on ArgumentError catch (err) {
      state = state.copyWith(errorMessage: err.message);
      rethrow;
    } on WrongCredentials catch (_) {
      state = state.copyWith(errorMessage: "Credenciales incorrectas");
      rethrow;
    }
  }

  Future<bool> loginWithGoogle(String idToken) async {
    try {
      final logResp = await authRepository.loginWithGoogle(idToken);

      await TokenManager.setTokens(
        accessToken: logResp.accessToken,
        refreshToken: logResp.refreshToken,
        expiry: DateTime.now().add(Duration(minutes: logResp.expiresIn)),
      );

      state = state.copyWith(
        user: logResp.user,
        authStatus: AuthStatus.authenticated,
        errorMessage: '',
      );
      return true;
    } on ArgumentError catch (err) {
      state = state.copyWith(errorMessage: err.message);
      return false;
    } on EmailAlreadyRegisterdManually catch (_) {
      state = state.copyWith(
        errorMessage:
            "Email ya fue registrado con otro metodo de autenticacion",
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        errorMessage: "No se pudo iniciar sesión con Google",
      );
      return false;
    }
  }

  Future<void> registerUser(User user) async {
    try {
      await authRepository.register(user);
    } on DuplicatedEmail catch (_) {
      state = state.copyWith(
        errorMessage: "Ya existe una cuenta con ese correo",
      );
      rethrow;
    } on ArgumentError catch (err) {
      state = state.copyWith(errorMessage: err.message);
      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> logout({String? errorMsg}) async {
    state = state.copyWith(
      user: null,
      authStatus: AuthStatus.notAuthenticated,
      errorMessage: errorMsg,
    );

    return true;
  }

  void updateUser(User updatedUser) {
    state = state.copyWith(user: updatedUser);
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
