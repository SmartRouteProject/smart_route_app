import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';
import 'package:smart_route_app/infrastructure/mocks/route_sample.dart';

final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  return MapNotifier();
});

class MapNotifier extends StateNotifier<MapState> {
  static const CameraPosition defaultCameraPosition = CameraPosition(
    target: LatLng(-32.8, -56.0),
    zoom: 6.0,
  );

  final IStopRepository _stopRepository;

  MapNotifier()
    : _stopRepository = StopRepositoryImpl(),
      super(
        MapState(routes: sampleRoutes, cameraPosition: defaultCameraPosition),
      ) {
    setCurrentPosition();
  }

  void selectRoute(RouteEnt? route) {
    state = state.copyWith(selectedRoute: route, clearSelectedStop: true);
  }

  void clearSelectedRoute() {
    state = state.copyWith(clearSelectedRoute: true, clearSelectedStop: true);
  }

  void selectStop(Stop? stop) {
    state = state.copyWith(selectedStop: stop);
  }

  void clearSelectedStop() {
    state = state.copyWith(clearSelectedStop: true);
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
    var index = updatedStops.indexWhere(
      (stop) => identical(stop, originalStop),
    );
    if (index == -1) {
      index = updatedStops.indexWhere(
        (stop) => _isSameStop(stop, originalStop),
      );
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

    final selectedStop = state.selectedStop;
    final updatedSelectedStop =
        selectedStop != null &&
            (identical(selectedStop, originalStop) ||
                _isSameStop(selectedStop, originalStop))
        ? updatedStop
        : selectedStop;

    state = state.copyWith(
      selectedRoute: updatedRoute,
      selectedStop: updatedSelectedStop,
      routes: List<RouteEnt>.unmodifiable(updatedRoutes),
    );
  }

  Future<bool> deleteStop(Stop stop) async {
    final selectedRoute = state.selectedRoute;
    final routeId = selectedRoute?.id ?? '';
    final stopId = stop.id ?? '';
    if (selectedRoute == null || routeId.isEmpty || stopId.isEmpty) {
      return false;
    }

    try {
      final deleted = await _stopRepository.deleteStop(routeId, stopId);
      if (!deleted) return false;

      final updatedStops = selectedRoute.stops
          .where((candidate) => !_isSameStopByIdOrFallback(candidate, stop))
          .toList();
      final updatedRoute = _copyRouteWithStops(selectedRoute, updatedStops);
      final updatedRoutes = state.routes
          .map((route) => route.id == updatedRoute.id ? updatedRoute : route)
          .toList();

      final selectedStop = state.selectedStop;
      final shouldClearSelected =
          selectedStop != null &&
          _isSameStopByIdOrFallback(selectedStop, stop);

      state = state.copyWith(
        selectedRoute: updatedRoute,
        selectedStop: shouldClearSelected ? null : selectedStop,
        routes: List<RouteEnt>.unmodifiable(updatedRoutes),
      );
      return true;
    } catch (err) {
      rethrow;
    }
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

  bool _isSameStopByIdOrFallback(Stop a, Stop b) {
    if (a.id != null && b.id != null) {
      return a.id == b.id;
    }
    return _isSameStop(a, b);
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
  final Stop? selectedStop;
  final CameraPosition cameraPosition;

  MapState({
    this.routes = const [],
    this.selectedRoute,
    this.selectedStop,
    required this.cameraPosition,
  });

  MapState copyWith({
    List<RouteEnt>? routes,
    RouteEnt? selectedRoute,
    Stop? selectedStop,
    CameraPosition? cameraPosition,
    bool clearSelectedRoute = false,
    bool clearSelectedStop = false,
  }) => MapState(
    routes: routes ?? this.routes,
    selectedRoute: clearSelectedRoute
        ? null
        : (selectedRoute ?? this.selectedRoute),
    selectedStop: clearSelectedStop
        ? null
        : (selectedStop ?? this.selectedStop),
    cameraPosition: cameraPosition ?? this.cameraPosition,
  );
}
