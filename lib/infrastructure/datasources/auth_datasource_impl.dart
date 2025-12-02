import 'package:dio_flow/dio_flow.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class AuthDatasourceImpl extends IAuthDatasource {
  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      final loginResponse = await DioRequestHandler.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
        requestOptions: RequestOptionsModel(hasBearerToken: false),
      );

      if (loginResponse is SuccessResponseModel) {
        final loginResp = LoginResponse.fromJson(
          loginResponse.data as Map<String, dynamic>,
        );
        return loginResp;
      } else if (loginResponse.statusCode == 401) {
        throw WrongCredentials();
      } else {
        throw 'Error del servidor, consultar con el administrados';
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<String> refreshToken(String token) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

  @override
  Future<bool> register(User user) async {
    try {
      final signupResponse = await DioRequestHandler.post(
        'auth/register',
        data: {'user': user},
        requestOptions: RequestOptionsModel(hasBearerToken: false),
      );

      if (signupResponse is SuccessResponseModel) {
        return true;
      } else {
        throw '❌ Error: ${signupResponse.error?.message}';
      }
    } catch (err) {
      rethrow;
    }
  }
}
