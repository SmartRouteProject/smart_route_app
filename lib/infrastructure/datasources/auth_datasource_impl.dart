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
        final apiResponse = LoginResponse.fromJson(loginResponse.data);

        return apiResponse;
      } else {
        final apiResponse = ApiResponse<LoginResponse>.fromJson(
          loginResponse.data,
          (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.error.code == 'AUTH002') {
          throw WrongCredentials();
        }
        throw ArgumentError(
          'Error del servidor, consultar con el administrador',
        );
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
        ApiEndpoints.registerUser,
        data: user.toMap(),
        requestOptions: RequestOptionsModel(hasBearerToken: false),
      );

      if (signupResponse is SuccessResponseModel) {
        return true;
      } else {
        final apiResponse = ApiResponse<LoginResponse>.fromJson(
          signupResponse.data,
          (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.error.code == 'USER003') {
          throw DuplicatedEmail();
        }
        throw ArgumentError(
          'Error del servidor, consultar con el administrador',
        );
      }
    } catch (err) {
      rethrow;
    }
  }
}
