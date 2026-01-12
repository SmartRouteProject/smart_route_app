import 'package:smart_route_app/domain/domain.dart';

abstract class Stop {
  String? id;
  double latitude;
  double longitude;
  String address;
  StopStatus status;
  DateTime? arrivalTime;
  String description;

  Stop({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.status = StopStatus.pending,
    this.arrivalTime,
    this.description = '',
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    final type = json['type'];

    switch (type) {
      case 'Delivery':
        return DeliveryStop.fromJson(json);
      case 'Pickup':
        return PickupStop.fromJson(json);
      default:
        throw Exception("Tipo de Stop desconocido: $type");
    }
  }

  Map<String, dynamic> toMap();
}
