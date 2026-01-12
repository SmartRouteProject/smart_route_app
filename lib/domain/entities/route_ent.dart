import 'package:smart_route_app/domain/domain.dart';

class RouteEnt {
  String id;
  String name;
  int? geometry;
  DateTime creationDate;
  DateTime? completionDate;
  RouteState state;
  List<Stop> stops;
  ReturnAddress? returnAddress;

  RouteEnt({
    required this.id,
    required this.name,
    required this.geometry,
    required this.creationDate,
    this.completionDate,
    required this.state,
    required this.stops,
    this.returnAddress,
  });

  factory RouteEnt.fromJson(Map<String, dynamic> json) {
    return RouteEnt(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String,
      geometry: json['geometry'] as int?,
      creationDate: DateTime.parse(json['creationDate']),
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'])
          : null,
      state: RouteState.values.firstWhere(
        (e) => e.name == json['state'],
        orElse: () => RouteState.planned,
      ),
      stops: (json['stops'] as List<dynamic>? ?? [])
          .map((e) => Stop.fromJson(e))
          .toList(),
      returnAddress: json['returnAddress'] != null
          ? ReturnAddress.fromJson(json['returnAddress'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'geometry': geometry,
      'creationDate': creationDate.toIso8601String(),
      'completionDate': completionDate?.toIso8601String(),
      'state': state.name,
      'stops': stops.map((s) => s.toMap()).toList(),
      'returnAddress': returnAddress?.toMap(),
    };
  }
}
