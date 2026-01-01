import 'package:dio_flow/dio_flow.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class MapsDatasourceImpl extends IMapsDatasource {
  @override
  Future<List<AddressSearch>> findPlace(String query) async {
    try {
      final response = await DioRequestHandler.get(
        ApiEndpoints.searchAddress,
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return _parseAddressList(response.data);
      } else {
        _handleMapsError(response.data);
        return [];
      }
    } catch (err) {
      rethrow;
    }
  }

  List<AddressSearch> _parseAddressList(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final apiResponse = ApiResponse<List<AddressSearch>>.fromJson(
        data,
        (json) => (json as List<dynamic>)
            .map((e) => AddressSearch.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return apiResponse.data ?? <AddressSearch>[];
    }

    if (data is List) {
      return data
          .map((e) => AddressSearch.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }

  void _handleMapsError(dynamic data) {
    final apiResponse = ApiResponse<dynamic>.fromJson(data, (json) => json);

    if (apiResponse.error.message.isNotEmpty) {
      throw ArgumentError(apiResponse.error.message);
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }
}
