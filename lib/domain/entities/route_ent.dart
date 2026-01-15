import 'package:smart_route_app/domain/domain.dart';

class RouteEnt {
  String id;
  String name;
  String? geometry;
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
      'geometry': geometry,
      'creationDate': creationDate.toIso8601String(),
      'completionDate': completionDate?.toIso8601String(),
      'state': state.name,
      'stops': stops.map((s) => s.toMap()).toList(),
      'returnAddress': returnAddress?.toMap(),
    };
  }
}

String? _parseGeometry(dynamic value) {
  if (value is String) {
    return value;
  }
  if (value is List) {
    final points = <_Coord>[];
    for (final point in value) {
      if (point is Map) {
        final latitude = point['latitude'] ?? point['lat'];
        final longitude = point['longitude'] ?? point['lng'] ?? point['lon'];
        if (latitude is num && longitude is num) {
          points.add(_Coord(latitude.toDouble(), longitude.toDouble()));
        }
      } else if (point is List && point.length >= 2) {
        final lat = point[0];
        final lng = point[1];
        if (lat is num && lng is num) {
          points.add(_Coord(lat.toDouble(), lng.toDouble()));
        }
      }
    }
    if (points.isEmpty) return null;
    return _encodePolyline(points);
  }
  return null;
}

class _Coord {
  final double latitude;
  final double longitude;

  const _Coord(this.latitude, this.longitude);
}

String _encodePolyline(List<_Coord> points) {
  var lastLat = 0;
  var lastLng = 0;
  final buffer = StringBuffer();

  for (final point in points) {
    final lat = (point.latitude * 1e5).round();
    final lng = (point.longitude * 1e5).round();
    buffer.write(_encodeValue(lat - lastLat));
    buffer.write(_encodeValue(lng - lastLng));
    lastLat = lat;
    lastLng = lng;
  }

  return buffer.toString();
}

String _encodeValue(int value) {
  var v = value << 1;
  if (value < 0) {
    v = ~v;
  }
  final buffer = StringBuffer();
  while (v >= 0x20) {
    final charCode = (0x20 | (v & 0x1f)) + 63;
    buffer.writeCharCode(charCode);
    v >>= 5;
  }
  buffer.writeCharCode(v + 63);
  return buffer.toString();
}
