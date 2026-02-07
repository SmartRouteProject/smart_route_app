import 'dart:convert';
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:dio_flow/dio_flow.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class ReportDatasourceImpl extends IReportDatasource {
  @override
  Future<Uint8List> generatePackagesReport(
    GeneratePackagesReportDto generatePackagesReportDto,
  ) async {
    try {
      final response = await DioRequestHandler.post(
        ApiEndpoints.generatePackagesReport,
        data: generatePackagesReportDto.toMap(),
        requestOptions: RequestOptionsModel(
          hasBearerToken: true,
          responseType: ResponseType.bytes,
        ),
      );

      if (response is SuccessResponseModel) {
        return _parseBytes(response.data);
      } else {
        _handleReportError(response.data);
        return Uint8List(0);
      }
    } catch (err) {
      rethrow;
    }
  }

  void _handleReportError(dynamic data) {
    final apiResponse = ApiResponse<dynamic>.fromJson(data, (json) => json);

    if (apiResponse.error.code == 'AUTH003') {
      throw InvalidToken();
    }
    if (apiResponse.error.message.isNotEmpty) {
      throw ArgumentError(apiResponse.error.message);
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }

  Uint8List _parseBytes(dynamic data) {
    if (data is Uint8List) return data;
    if (data is List<int>) return Uint8List.fromList(data);
    if (data is List) {
      final ints = data
          .whereType<num>()
          .map((value) => value.toInt())
          .toList(growable: false);
      if (ints.isNotEmpty) {
        return Uint8List.fromList(ints);
      }
    }
    if (data is String) {
      final trimmed = data.trim();
      try {
        final payload = trimmed.contains(',')
            ? trimmed.split(',').last
            : trimmed;
        return base64Decode(payload);
      } catch (_) {}
    }
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return _parseBytes(data['data']);
    }
    if (data is Map<String, dynamic>) {
      if (data.containsKey('file')) return _parseBytes(data['file']);
      if (data.containsKey('bytes')) return _parseBytes(data['bytes']);
      if (data.containsKey('content')) return _parseBytes(data['content']);
    }

    throw ArgumentError('Error del servidor, consultar con el administrador');
  }
}
