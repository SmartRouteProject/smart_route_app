class OptimizationRequestDto {
  final bool optimizeStopOrder;
  final OptimizationOrigin origin;

  OptimizationRequestDto({
    required this.optimizeStopOrder,
    required this.origin,
  });

  Map<String, dynamic> toMap() {
    return {
      'optimizeStopOrder': optimizeStopOrder,
      'origin': origin.toMap(),
    };
  }
}

class OptimizationOrigin {
  final double latitude;
  final double longitude;

  OptimizationOrigin({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
