import 'package:smart_route_app/domain/domain.dart';

class PickupStop extends Stop {
  PickupStop({
    required super.latitude,
    required super.longitude,
    required super.address,
    super.status = StopStatus.pending,
  });

  factory PickupStop.fromJson(Map<String, dynamic> json) {
    return PickupStop(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] ?? '',
      status: json['status'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status,
    };
  }
}
