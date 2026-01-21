import 'package:smart_route_app/infrastructure/infrastructure.dart';

abstract class IReportDatasource {
  Future<dynamic> generatePackagesReport(
    GeneratePackagesReportDto generatePackagesReportDto,
  );
}
