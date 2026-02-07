import 'package:smart_route_app/domain/domain.dart';

class CreateRouteDto {
  final String name;
  final DateTime creationDate;
  final ReturnAddress? returnAddress;

  CreateRouteDto({
    required this.name,
    required this.creationDate,
    required this.returnAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'creationDate': creationDate.toIso8601String(),
      'returnAddress': returnAddress?.toMap(),
    };
  }
}
