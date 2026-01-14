import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:smart_route_app/domain/domain.dart';

class RouteEnt {
  String id;
  String name;
  List<LatLng>? geometry;
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
      geometry: _parseGeometry(json['geometry']),
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
      'geometry': geometry
          ?.map(
            (point) => {
              'latitude': point.latitude,
              'longitude': point.longitude,
            },
          )
          .toList(),
      'creationDate': creationDate.toIso8601String(),
      'completionDate': completionDate?.toIso8601String(),
      'state': state.name,
      'stops': stops.map((s) => s.toMap()).toList(),
      'returnAddress': returnAddress?.toMap(),
    };
  }
}

List<LatLng>? _parseGeometry(dynamic value) {
  if (value is! List) return null;

  return value
      .map<LatLng?>((point) {
        if (point is Map) {
          final latitude = point['latitude'] ?? point['lat'];
          final longitude =
              point['longitude'] ?? point['lng'] ?? point['lon'];
          if (latitude is num && longitude is num) {
            return LatLng(latitude.toDouble(), longitude.toDouble());
          }
        } else if (point is List && point.length >= 2) {
          final lat = point[0];
          final lng = point[1];
          if (lat is num && lng is num) {
            return LatLng(lat.toDouble(), lng.toDouble());
          }
        }
        return null;
      })
      .whereType<LatLng>()
      .toList();
}
