import 'dart:typed_data';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

class ReportRepositoryImpl extends IReportRepository {
  final IReportDatasource reportDatasource;

  ReportRepositoryImpl({IReportDatasource? reportDatasource})
    : reportDatasource = reportDatasource ?? ReportDatasourceImpl();

  @override
  Future<Uint8List> generatePackagesReport(
    GeneratePackagesReportDto generatePackagesReportDto,
  ) {
    return reportDatasource.generatePackagesReport(generatePackagesReportDto);
  }
}
