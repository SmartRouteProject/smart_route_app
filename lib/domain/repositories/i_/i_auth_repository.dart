import 'package:smart_route_app/domain/domain.dart';

abstract class IAuthRepository {
  Future<User> login(String email, String password);

  Future<bool> register(String email, String password);

  Future<String> refreshToken(String token);

  Future<bool> logout();
}
