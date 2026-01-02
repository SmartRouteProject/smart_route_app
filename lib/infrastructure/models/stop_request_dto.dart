import 'package:smart_route_app/domain/domain.dart';

class StopRequestDto {
  final double latitude;
  final double longitude;
  final String address;
  final String stopType;
  final List<Package> packages;

  StopRequestDto({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.stopType,
    required this.packages,
  });

  factory StopRequestDto.fromStop(Stop stop, {List<Package>? packages}) {
    final stopType = stop is DeliveryStop ? 'Delivery' : 'Pickup';
    return StopRequestDto(
      latitude: stop.latitude,
      longitude: stop.longitude,
      address: stop.address,
      stopType: stopType,
      packages: packages ?? const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'stopType': stopType,
      'packages': packages.map((package) => package.toMap()).toList(),
    };
  }
}
