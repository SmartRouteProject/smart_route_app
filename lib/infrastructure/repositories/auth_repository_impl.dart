import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class AuthRepositoryImpl extends IAuthRepository {
  final IAuthDatasource authDatasource;

  AuthRepositoryImpl({IAuthDatasource? authDatasource})
    : authDatasource = authDatasource ?? AuthDatasourceImpl();

  @override
  Future<User> login(String email, String password) {
    return authDatasource.login(email, password);
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
  Future<bool> register(String email, String password) {
    return authDatasource.register(email, password);
  }
}
