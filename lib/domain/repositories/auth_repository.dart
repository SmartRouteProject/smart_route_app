import 'package:smart_route_app/domain/domain.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);

  Future<bool> register(String email, String password);

  Future<String> refreshToken(String token);

  Future<bool> logout();
}
