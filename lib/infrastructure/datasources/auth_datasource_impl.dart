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
          throw AUTH002WrongCredentials();
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
  Future<LoginResponse> loginWithGoogle(String idToken) async {
    try {
      final loginResponse = await DioRequestHandler.post(
        ApiEndpoints.authGoogle,
        data: {'idToken': idToken},
        requestOptions: RequestOptionsModel(hasBearerToken: false),
      );

      if (loginResponse is SuccessResponseModel) {
        return LoginResponse.fromJson(loginResponse.data);
      } else {
        final apiResponse = ApiResponse<LoginResponse>.fromJson(
          loginResponse.data,
          (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.error.code == "AUTH004") {
          throw AUTH004EmailAlreadyRegisteredManually();
        } else if (apiResponse.error.message.isNotEmpty) {
          throw ArgumentError(apiResponse.error.message);
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
          throw USER003DuplicatedEmail();
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
  Future<bool> sendEmailVerification(String email) async {
    try {
      final response = await DioRequestHandler.post(
        ApiEndpoints.sendEmailVerification,
        data: {'email': email},
        requestOptions: RequestOptionsModel(hasBearerToken: false),
      );

      if (response is SuccessResponseModel) {
        return true;
      } else {
        final apiResponse = ApiResponse<Object?>.fromJson(
          response.data,
          (json) => json,
        );

        if (apiResponse.error.message.isNotEmpty) {
          throw ArgumentError(apiResponse.error.message);
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
  Future<bool> verifyEmail(String email, String code) async {
    try {
      final response = await DioRequestHandler.post(
        ApiEndpoints.verifyEmail,
        data: {'email': email, 'code': code},
        requestOptions: RequestOptionsModel(hasBearerToken: false),
      );

      if (response is SuccessResponseModel) {
        return true;
      } else {
        final apiResponse = ApiResponse<Object?>.fromJson(
          response.data,
          (json) => json,
        );

        if (apiResponse.error.code == "AUTH007") {
          throw AUTH007InvalidVerificationCode();
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
  Future<bool> requestPasswordChange(String email) async {
    try {
      final response = await DioRequestHandler.post(
        ApiEndpoints.requestPasswordChange,
        data: {'email': email},
        requestOptions: RequestOptionsModel(hasBearerToken: false),
      );

      if (response is SuccessResponseModel) {
        return true;
      } else {
        final apiResponse = ApiResponse<Object?>.fromJson(
          response.data,
          (json) => json,
        );

        if (apiResponse.error.message.isNotEmpty) {
          throw ArgumentError(apiResponse.error.message);
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
  Future<bool> verifyPasswordChange(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      final response = await DioRequestHandler.post(
        ApiEndpoints.verifyPasswordChange,
        data: {'email': email, 'code': code, 'newPassword': newPassword},
        requestOptions: RequestOptionsModel(hasBearerToken: false),
      );

      if (response is SuccessResponseModel) {
        return true;
      } else {
        final apiResponse = ApiResponse<Object?>.fromJson(
          response.data,
          (json) => json,
        );

        if (apiResponse.error.code == "AUTH007") {
          throw AUTH007InvalidVerificationCode();
        }
        if (apiResponse.error.message.isNotEmpty) {
          throw ArgumentError(apiResponse.error.message);
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
