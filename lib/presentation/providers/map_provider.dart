import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/mocks/route_sample.dart';

final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  return MapNotifier();
});

class MapNotifier extends StateNotifier<MapState> {
  static const CameraPosition defaultCameraPosition = CameraPosition(
    target: LatLng(-32.8, -56.0),
    zoom: 6.0,
  );

  MapNotifier()
    : super(
        MapState(routes: sampleRoutes, cameraPosition: defaultCameraPosition),
      ) {
    setCurrentPosition();
  }

  void selectRoute(RouteEnt? route) {
    state = state.copyWith(selectedRoute: route);
  }

  void clearSelectedRoute() {
    state = state.copyWith(clearSelection: true);
  }

  void setRoutes(List<RouteEnt> routes) {
    state = state.copyWith(routes: List<RouteEnt>.unmodifiable(routes));
  }

  void addRoute(RouteEnt route) {
    state = state.copyWith(routes: [...state.routes, route]);
  }

  Future<void> setCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      state = state.copyWith(
        cameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14.4746,
        ),
      );
    } catch (_) {}
  }
}

class MapState {
  final List<RouteEnt> routes;
  final RouteEnt? selectedRoute;
  final CameraPosition cameraPosition;

  MapState({
    this.routes = const [],
    this.selectedRoute,
    required this.cameraPosition,
  });

  MapState copyWith({
    List<RouteEnt>? routes,
    RouteEnt? selectedRoute,
    CameraPosition? cameraPosition,
    bool clearSelection = false,
  }) => MapState(
    routes: routes ?? this.routes,
    selectedRoute: clearSelection
        ? null
        : (selectedRoute ?? this.selectedRoute),
    cameraPosition: cameraPosition ?? this.cameraPosition,
  );
}
