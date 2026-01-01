import 'package:dio_flow/dio_flow.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class StopDatasourceImpl extends IStopDatasource {
  @override
  Future<List<Stop>> getStops(String routeId) async {
    try {
      final response = await DioRequestHandler.get(
        ApiEndpoints.getStopsByRoute(routeId),
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return _parseStopList(response.data);
      } else {
        _handleStopError(response.data);
        return [];
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<Stop?> createStop(String routeId, Stop stop) async {
    try {
      final response = await DioRequestHandler.post(
        ApiEndpoints.createStop,
        data: {'routeId': routeId, ...stop.toMap()},
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return _parseStop(response.data);
      } else {
        _handleStopError(response.data);
        return null;
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<Stop?> editStop(String routeId, Stop stop) async {
    try {
      final response = await DioRequestHandler.put(
        ApiEndpoints.updateStop(routeId: routeId, stopId: stop.id!),
        data: {'routeId': routeId, ...stop.toMap()},
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return _parseStop(response.data);
      } else {
        _handleStopError(response.data);
        return null;
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteStop(String routeId, String stopId) async {
    try {
      final response = await DioRequestHandler.delete(
        ApiEndpoints.deleteStop(routeId: routeId, stopId: stopId),
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return true;
      } else {
        _handleStopError(response.data);
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  List<Stop> _parseStopList(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final apiResponse = ApiResponse<List<Stop>>.fromJson(
        data,
        (json) => (json as List<dynamic>)
            .map((e) => Stop.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return apiResponse.data ?? <Stop>[];
    }

    if (data is List) {
      return data.map((e) => Stop.fromJson(e as Map<String, dynamic>)).toList();
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }

  Stop _parseStop(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final apiResponse = ApiResponse<Stop>.fromJson(
        data,
        (json) => Stop.fromJson(json as Map<String, dynamic>),
      );
      if (apiResponse.data != null) {
        return apiResponse.data!;
      }
    }

    if (data is Map<String, dynamic>) {
      return Stop.fromJson(data);
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }

  void _handleStopError(dynamic data) {
    final apiResponse = ApiResponse<dynamic>.fromJson(data, (json) => json);

    if (apiResponse.error.message.isNotEmpty) {
      throw ArgumentError(apiResponse.error.message);
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }
}
