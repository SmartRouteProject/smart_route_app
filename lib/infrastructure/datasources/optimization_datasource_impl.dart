import 'package:dio_flow/dio_flow.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class OptimizationDatasourceImpl extends IOptimizationDatasource {
  @override
  Future<RouteEnt?> optimizeRoute(
    String routeId,
    OptimizationRequestDto optimizationRequestDto,
  ) async {
    try {
      final dataToSend = optimizationRequestDto.toMap();
      final response = await DioRequestHandler.post(
        ApiEndpoints.optimizeRoute(routeId),
        data: dataToSend,
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return _parseRoute(response.data);
      } else {
        _handleOptimizationError(response.data);
        return null;
      }
    } catch (err) {
      rethrow;
    }
  }

  RouteEnt _parseRoute(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final apiResponse = ApiResponse<RouteEnt>.fromJson(
        data,
        (json) => RouteEnt.fromJson(json as Map<String, dynamic>),
      );
      if (apiResponse.data != null) {
        return apiResponse.data!;
      }
    }

    if (data is Map<String, dynamic>) {
      return RouteEnt.fromJson(data);
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }

  void _handleOptimizationError(dynamic data) {
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
