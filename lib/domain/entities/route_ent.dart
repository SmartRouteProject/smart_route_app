import 'package:smart_route_app/domain/domain.dart';

class RouteEnt {
  int? id;
  String name;
  int geometry;
  DateTime creationDate;
  RouteState state;
  List<Stop> stops;
  ReturnAddress returnAddress;

  RouteEnt({
    this.id,
    required this.name,
    required this.geometry,
    required this.creationDate,
    required this.state,
    required this.stops,
    required this.returnAddress,
  });

  factory RouteEnt.fromJson(Map<String, dynamic> json) {
    return RouteEnt(
      id: json['id'] as int?,
      name: json['name'] as String,
      geometry: json['geometry'] as int,
      creationDate: DateTime.parse(json['creationDate']),
      state: RouteState.values.firstWhere(
        (e) => e.name == json['state'],
        orElse: () => RouteState.planned,
      ),
      stops: (json['stops'] as List<dynamic>? ?? [])
          .map((e) => Stop.fromJson(e))
          .toList(),
      returnAddress: ReturnAddress.fromJson(json['returnAddress']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'geometry': geometry,
      'creationDate': creationDate.toIso8601String(),
      'state': state.name,
      'stops': stops.map((s) => s.toMap()).toList(),
      'returnAddress': returnAddress.toMap(),
    };
  }
}
