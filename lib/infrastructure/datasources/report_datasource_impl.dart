import 'package:dio_flow/dio_flow.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class ReportDatasourceImpl extends IReportDatasource {
  @override
  Future<dynamic> generatePackagesReport(
    GeneratePackagesReportDto generatePackagesReportDto,
  ) async {
    try {
      final response = await DioRequestHandler.post(
        ApiEndpoints.generatePackagesReport,
        data: generatePackagesReportDto.toMap(),
        requestOptions: RequestOptionsModel(hasBearerToken: true),
      );

      if (response is SuccessResponseModel) {
        return response.data;
      } else {
        _handleReportError(response.data);
        return null;
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
}
