import 'package:smart_route_app/domain/domain.dart';

class StopRequestDto {
  final double latitude;
  final double longitude;
  final String address;
  final String stopType;
  final DateTime? arrivalTime;
  final int? order;
  final String description;
  final List<Package> packages;

  StopRequestDto({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.stopType,
    required this.arrivalTime,
    required this.order,
    required this.description,
    required this.packages,
  });

  factory StopRequestDto.fromStop(Stop stop, {List<Package>? packages}) {
    final stopType = stop is DeliveryStop ? 'Delivery' : 'Pickup';
    final resolvedPackages =
        packages ??
        (stop is DeliveryStop ? stop.packages : const <Package>[]);
    return StopRequestDto(
      latitude: stop.latitude,
      longitude: stop.longitude,
      address: stop.address,
      stopType: stopType,
      arrivalTime: stop.arrivalTime,
      order: stop.order,
      description: stop.description,
      packages: resolvedPackages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'stopType': stopType,
      'arrivalTime': arrivalTime?.toIso8601String(),
      'order': order,
      'description': description,
      'packages': packages.map((package) => package.toMap()).toList(),
    };
  }
}
