import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

abstract class IAuthDatasource {
  Future<LoginResponse> login(String email, String password);

  Future<LoginResponse> loginWithGoogle(String idToken);

  Future<bool> register(User user);

  Future<String> refreshToken(String token);

  Future<bool> logout();

  Future<bool> sendEmailVerification(String email);

  Future<bool> verifyEmail(String email, String code);
}
