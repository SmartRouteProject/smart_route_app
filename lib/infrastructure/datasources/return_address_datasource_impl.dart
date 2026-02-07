import 'package:dio_flow/dio_flow.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/errors/return_address_errors.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class ReturnAddressDatasourceImpl extends IReturnAddressDatasource {
  @override
  Future<List<ReturnAddress>> getReturnAddresses() async {
    try {
      final response = await DioRequestHandler.get(
        ApiEndpoints.getReturnAddresses,
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return _parseReturnAddressList(response.data);
      } else {
        _handleReturnAddressError(response.data);
        return [];
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<ReturnAddress?> createReturnAddress(ReturnAddress address) async {
    try {
      final response = await DioRequestHandler.post(
        ApiEndpoints.createReturnAddress,
        data: address.toMap(),
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return _parseReturnAddress(response.data);
      } else {
        _handleReturnAddressError(response.data);
        return null;
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<ReturnAddress?> editReturnAddress(
    String id,
    ReturnAddress address,
  ) async {
    try {
      final response = await DioRequestHandler.put(
        ApiEndpoints.updateReturnAddress(id),
        data: address.toMap(),
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return _parseReturnAddress(response.data);
      } else {
        _handleReturnAddressError(response.data);
        return null;
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteReturnAddress(String id) async {
    try {
      final response = await DioRequestHandler.delete(
        ApiEndpoints.deleteReturnAddress(id),
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return true;
      } else {
        _handleReturnAddressError(response.data);
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  List<ReturnAddress> _parseReturnAddressList(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final apiResponse = ApiResponse<List<ReturnAddress>>.fromJson(
        data,
        (json) => (json as List<dynamic>)
            .map((e) => ReturnAddress.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return apiResponse.data ?? <ReturnAddress>[];
    }

    if (data is List) {
      return data
          .map((e) => ReturnAddress.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }

  ReturnAddress _parseReturnAddress(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final apiResponse = ApiResponse<ReturnAddress>.fromJson(
        data,
        (json) => ReturnAddress.fromJson(json as Map<String, dynamic>),
      );
      if (apiResponse.data != null) {
        return apiResponse.data!;
      }
    }

    if (data is Map<String, dynamic>) {
      return ReturnAddress.fromJson(data);
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }

  void _handleReturnAddressError(dynamic data) {
    final apiResponse = ApiResponse<dynamic>.fromJson(data, (json) => json);

    if (apiResponse.error.message.isNotEmpty) {
      if (apiResponse.error.code == "ADDR002") {
        throw ADDR002DuplicatedAddress();
      } else {
        throw ArgumentError(apiResponse.error.message);
      }
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }
}
