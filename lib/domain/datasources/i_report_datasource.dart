import 'dart:typed_data';

import 'package:smart_route_app/infrastructure/infrastructure.dart';

abstract class IReportDatasource {
  Future<Uint8List> generatePackagesReport(
    GeneratePackagesReportDto generatePackagesReportDto,
  );
}
