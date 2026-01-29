import 'package:smart_route_app/domain/enums/package_weight_type.dart';

class GeneratePackagesReportDto {
  final DateTime from;
  final DateTime to;
  final PackageWeightType weightFilter;
  final String format;

  GeneratePackagesReportDto({
    required this.from,
    required this.to,
    required this.weightFilter,
    required this.format,
  });

  Map<String, dynamic> toMap() {
    return {
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'weightFilter': weightFilter.name,
      'format': format,
    };
  }
}
