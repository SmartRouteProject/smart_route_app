import 'package:dio_flow/dio_flow.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class RouteDatasourceImpl extends IRouteDatasource {
  @override
  Future<List<RouteEnt>> getRoutes() async {
    try {
      final response = await DioRequestHandler.get(
        ApiEndpoints.getUserRoutes,
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return _parseRouteList(response.data);
      } else {
        _handleRouteError(response.data);
        return [];
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<RouteEnt?> getRoute(int id) async {
    try {
      final response = await DioRequestHandler.get(
        ApiEndpoints.getRouteById("$id"),
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return _parseRoute(response.data);
      } else {
        _handleRouteError(response.data);
        return null;
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<RouteEnt?> createRoute(CreateRouteDto createRouteDto) async {
    try {
      final response = await DioRequestHandler.post(
        ApiEndpoints.createRoute,
        data: createRouteDto.toMap(),
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return _parseRoute(response.data);
      } else {
        _handleRouteError(response.data);
        return null;
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<RouteEnt?> updateRoute(RouteEnt route) async {
    try {
      final response = await DioRequestHandler.put(
        ApiEndpoints.getRouteById("${route.id}"),
        data: {
          'name': route.name,
          'date': route.creationDate.toIso8601String(),
          'state': _serializeRouteState(route.state),
        },
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return _parseRoute(response.data);
      } else {
        _handleRouteError(response.data);
        return null;
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteRoute(int id) async {
    try {
      final response = await DioRequestHandler.delete(
        ApiEndpoints.getRouteById("$id"),
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return true;
      } else {
        _handleRouteError(response.data);
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  List<RouteEnt> _parseRouteList(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final apiResponse = ApiResponse<List<RouteEnt>>.fromJson(
        data,
        (json) => (json as List<dynamic>)
            .map((e) => RouteEnt.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return apiResponse.data ?? <RouteEnt>[];
    }

    if (data is List) {
      return data
          .map((e) => RouteEnt.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
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

  void _handleRouteError(dynamic data) {
    final apiResponse = ApiResponse<dynamic>.fromJson(data, (json) => json);

    if (apiResponse.error.code == 'AUTH003') {
      throw InvalidToken();
    }
    if (apiResponse.error.message.isNotEmpty) {
      throw ArgumentError(apiResponse.error.message);
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }

  String _serializeRouteState(RouteState state) {
    return '${state.name[0].toUpperCase()}${state.name.substring(1)}';
  }
}
