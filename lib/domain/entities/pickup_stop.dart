import 'package:smart_route_app/domain/domain.dart';

class PickupStop extends Stop {
  PickupStop({
    super.id,
    required super.latitude,
    required super.longitude,
    required super.address,
    super.status = StopStatus.pending,
  });

  factory PickupStop.fromJson(Map<String, dynamic> json) {
    return PickupStop(
      id: json['id']?.toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] ?? '',
      status: StopStatus.fromString(json['status'] ?? ''),
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
    };
  }
}
