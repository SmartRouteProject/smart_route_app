import 'package:smart_route_app/domain/domain.dart';

class DeliveryStop extends Stop {
  List<Package> packages;
  // En el diagrama no hay atributos propios, solo hereda de Stop.
  // Si querés agregar la lista de paquetes, podés descomentar lo de abajo.
  //
  // List<Package> packages;

  DeliveryStop({
    super.id,
    required super.latitude,
    required super.longitude,
    required super.address,
    super.status = StopStatus.pending,
    super.arrivalTime,
    super.closedTime,
    super.order,
    super.description = '',
    List<Package> packages = const [],
  }) : packages = List<Package>.from(packages);

  factory DeliveryStop.fromJson(Map<String, dynamic> json) {
    return DeliveryStop(
      id: json['id']?.toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] ?? '',
      status: StopStatus.fromString(json['status'] ?? ''),
      arrivalTime: _parseArrivalTime(json['arrivalTime']),
      closedTime: _parseArrivalTime(json['closedTime']),
      order: _parseOrder(json['order']),
      description: json['description'] ?? '',
      packages:
          (json['packages'] as List<dynamic>?)
              ?.map((e) => Package.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status.getStringValue(),
      'arrivalTime': arrivalTime?.toIso8601String(),
      'closedTime': closedTime?.toIso8601String(),
      'order': order,
      'description': description,
      'packages': packages.map((package) => package.toMap()).toList(),
    };
  }

  static DateTime? _parseArrivalTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static int? _parseOrder(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String && value.isNotEmpty) {
      return int.tryParse(value);
    }
    return null;
  }
}
