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

  void upsertStop({required Stop originalStop, required Stop updatedStop}) {
    final selectedRoute = state.selectedRoute;
    if (selectedRoute == null) return;

    final updatedStops = List<Stop>.from(selectedRoute.stops);
    var index = updatedStops.indexWhere((stop) => identical(stop, originalStop));
    if (index == -1) {
      index = updatedStops.indexWhere((stop) => _isSameStop(stop, originalStop));
    }

    if (index == -1) {
      updatedStops.add(updatedStop);
    } else {
      updatedStops[index] = updatedStop;
    }

    final updatedRoute = _copyRouteWithStops(selectedRoute, updatedStops);
    final updatedRoutes = state.routes
        .map((route) => route.id == updatedRoute.id ? updatedRoute : route)
        .toList();

    state = state.copyWith(
      selectedRoute: updatedRoute,
      routes: List<RouteEnt>.unmodifiable(updatedRoutes),
    );
  }

  RouteEnt _copyRouteWithStops(RouteEnt route, List<Stop> stops) {
    return RouteEnt(
      id: route.id,
      name: route.name,
      geometry: route.geometry,
      creationDate: route.creationDate,
      state: route.state,
      stops: stops,
      returnAddress: route.returnAddress,
    );
  }

  bool _isSameStop(Stop a, Stop b) {
    return a.latitude == b.latitude &&
        a.longitude == b.longitude &&
        a.address == b.address;
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
