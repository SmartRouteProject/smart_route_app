import 'package:smart_route_app/domain/domain.dart';

abstract class IAuthDatasource {
  Future<User> login(String email, String password);

  Future<bool> register(User user);

  Future<String> refreshToken(String token);

  Future<bool> logout();
}
