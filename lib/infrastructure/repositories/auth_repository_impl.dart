import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class AuthRepositoryImpl extends IAuthRepository {
  final IAuthDatasource authDatasource;

  AuthRepositoryImpl({IAuthDatasource? authDatasource})
    : authDatasource = authDatasource ?? AuthDatasourceImpl();

  @override
  Future<LoginResponse> login(String email, String password) {
    return authDatasource.login(email, password);
  }

  @override
  Future<LoginResponse> loginWithGoogle(String idToken) {
    return authDatasource.loginWithGoogle(idToken);
  }

  @override
  Future<bool> logout() {
    return authDatasource.logout();
  }

  @override
  Future<String> refreshToken(String token) {
    return authDatasource.refreshToken(token);
  }

  @override
  Future<bool> register(User user) {
    return authDatasource.register(user);
  }

  @override
  Future<bool> sendEmailVerification(String email) {
    return authDatasource.sendEmailVerification(email);
  }

  @override
  Future<bool> verifyEmail(String email, String code) {
    return authDatasource.verifyEmail(email, code);
  }
}
