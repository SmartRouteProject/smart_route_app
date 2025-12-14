import 'package:dio_flow/dio_flow.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class UserDatasourceImpl extends IUserDatasource {
  @override
  Future<User> editUser(User user) async {
    try {
      final response = await DioRequestHandler.post(
        ApiEndpoints.editUserProfile,
        data: user.toMap(),
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        if (response.data is Map<String, dynamic> &&
            (response.data as Map<String, dynamic>).containsKey('data')) {
          final apiResponse = ApiResponse<User>.fromJson(
            response.data,
            (json) => User.fromJson(json as Map<String, dynamic>),
          );

          if (apiResponse.data != null) {
            return apiResponse.data!;
          }
        }
        return User.fromJson(response.data);
      } else {
        final apiResponse = ApiResponse<User>.fromJson(
          response.data,
          (json) => User.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.error.code == 'AUTH003') {
          throw InvalidToken();
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
