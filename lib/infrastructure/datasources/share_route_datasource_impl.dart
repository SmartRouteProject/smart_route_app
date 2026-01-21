import 'package:dio_flow/dio_flow.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';
import 'package:smart_route_app/infrastructure/models/share_route_response.dart';

class ShareRouteDatasourceImpl extends IShareRouteDatasource {
  @override
  Future<String?> shareRoute(String routeId) async {
    try {
      final response = await DioRequestHandler.post(
        ApiEndpoints.shareRoute(routeId),
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        final apiResponse = ShareRouteResponse.fromJson(response.data);
        return apiResponse.shareLink;
      } else {
        _handleShareRouteError(response.data);
        return null;
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> acceptSharedRoute(String sharedRouteId) async {
    try {
      final response = await DioRequestHandler.post(
        ApiEndpoints.acceptSharedRoute(sharedRouteId),
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return true;
      } else {
        _handleShareRouteError(response.data);
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  void _handleShareRouteError(dynamic data) {
    final apiResponse = ApiResponse<dynamic>.fromJson(data, (json) => json);

    if (apiResponse.error.code == 'AUTH003') {
      throw InvalidToken();
    }
    if (apiResponse.error.message.isNotEmpty) {
      throw ArgumentError(apiResponse.error.message);
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }
}
