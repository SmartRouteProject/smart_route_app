import 'package:smart_route_app/domain/domain.dart';

class PickupStop extends Stop {
  PickupStop({
    super.id,
    required super.latitude,
    required super.longitude,
    required super.address,
    super.status = StopStatus.pending,
    super.arrivalTime,
    super.description = '',
  });

  factory PickupStop.fromJson(Map<String, dynamic> json) {
    return PickupStop(
      id: json['id']?.toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] ?? '',
      status: StopStatus.fromString(json['status'] ?? ''),
      arrivalTime: _parseArrivalTime(json['arrivalTime']),
      description: json['description'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status,
      'arrivalTime': arrivalTime?.toIso8601String(),
      'description': description,
    };
  }

  static DateTime? _parseArrivalTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
