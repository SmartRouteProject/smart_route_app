import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

abstract class IAuthDatasource {
  Future<LoginResponse> login(String email, String password);

  Future<bool> register(User user);

  Future<String> refreshToken(String token);

  Future<bool> logout();
}
