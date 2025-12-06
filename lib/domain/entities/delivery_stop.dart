import 'package:smart_route_app/domain/domain.dart';

class DeliveryStop extends Stop {
  // En el diagrama no hay atributos propios, solo hereda de Stop.
  // Si querés agregar la lista de paquetes, podés descomentar lo de abajo.
  //
  // List<Package> packages;

  DeliveryStop({
    required super.latitude,
    required super.longitude,
    required super.address,
    super.status = StopStatus.pending,
    // required this.packages,
  });

  factory DeliveryStop.fromJson(Map<String, dynamic> json) {
    return DeliveryStop(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] ?? '',
      status: json['status'] ?? '',
      // packages: (json['packages'] as List<dynamic>?)
      //         ?.map((e) => Package.fromJson(e as Map<String, dynamic>))
      //         .toList() ??
      //     [],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status,
      // 'packages': packages.map((p) => p.toJson()).toList(),
    };
  }
}
