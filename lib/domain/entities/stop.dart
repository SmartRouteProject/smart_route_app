import 'package:smart_route_app/domain/domain.dart';

abstract class Stop {
  String? id;
  double latitude;
  double longitude;
  String address;
  StopStatus status;

  Stop({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.status = StopStatus.pending,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    final type = json['type'];

    switch (type) {
      case 'delivery':
        return DeliveryStop.fromJson(json);
      case 'pickup':
        return PickupStop.fromJson(json);
      default:
        throw Exception("Tipo de Stop desconocido: $type");
    }
  }

  Map<String, dynamic> toMap();
}
