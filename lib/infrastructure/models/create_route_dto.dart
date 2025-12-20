import 'package:smart_route_app/domain/domain.dart';

class CreateRouteDto {
  final String name;
  final DateTime date;
  final ReturnAddress? returnAddress;

  CreateRouteDto({
    required this.name,
    required this.date,
    required this.returnAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date.toIso8601String(),
      'returnAddress': returnAddress?.toMap(),
    };
  }
}
