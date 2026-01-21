import 'package:smart_route_app/infrastructure/infrastructure.dart';

abstract class IReportRepository {
  Future<dynamic> generatePackagesReport(
    GeneratePackagesReportDto generatePackagesReportDto,
  );
}
