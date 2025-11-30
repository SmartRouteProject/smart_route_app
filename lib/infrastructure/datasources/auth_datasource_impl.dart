import 'package:dio_flow/dio_flow.dart';

import 'package:smart_route_app/domain/domain.dart';

class AuthDatasourceImpl extends IAuthDatasource {
  @override
  Future<User> login(String email, String password) async {
    try {
      final loginResponse = await DioRequestHandler.post(
        'auth/login',
        data: {'email': email, 'password': password},
        requestOptions: RequestOptionsModel(hasBearerToken: false),
      );

      if (loginResponse is SuccessResponseModel) {
        final user = User.fromJson(loginResponse.data as Map<String, dynamic>);
        return user;
      } else {
        throw '❌ Error: ${loginResponse.error?.message}';
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
  Future<bool> register(String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
