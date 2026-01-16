import 'dart:ui';

import 'package:flutter_polyline_points_plus/flutter_polyline_points_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';
import 'package:smart_route_app/infrastructure/mocks/route_sample.dart';
import 'package:smart_route_app/presentation/providers/auth_provider.dart';

final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  final routeRepository = RouteRepositoryImpl();
  return MapNotifier(ref: ref, routeRepository: routeRepository);
});

final mapErrorProvider = Provider<String>((ref) {
  return ref.watch(mapProvider).errorMessage;
});

class MapNotifier extends StateNotifier<MapState> {
  static const CameraPosition defaultCameraPosition = CameraPosition(
    target: LatLng(-32.8, -56.0),
    zoom: 6.0,
  );

  final IStopRepository _stopRepository;
  final IRouteRepository _routeRepository;
  final Ref _ref;

  MapNotifier({required Ref ref, required IRouteRepository routeRepository})
    : _ref = ref,
      _stopRepository = StopRepositoryImpl(),
      _routeRepository = routeRepository,
      super(
        MapState(routes: sampleRoutes, cameraPosition: defaultCameraPosition),
      ) {
    setCurrentPosition();
  }

  void selectRoute(RouteEnt? route) {
    state = state.copyWith(
      selectedRoute: route,
      clearSelectedStop: true,
      polylines: _buildRoutePolylines(route),
    );
  }

  void clearSelectedRoute() {
    state = state.copyWith(
      clearSelectedRoute: true,
      clearSelectedStop: true,
      polylines: const <Polyline>{},
    );
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

  void setMapController(GoogleMapController controller) {
    state = state.copyWith(mapController: controller);
  }

  void addRoute(RouteEnt route) {
    state = state.copyWith(routes: [...state.routes, route]);
  }

  bool addPackageToSelectedStop(Package package) {
    final selectedStop = state.selectedStop;
    if (selectedStop == null) return false;
    if (selectedStop is! DeliveryStop) return false;

    final updatedStop = DeliveryStop(
      id: selectedStop.id,
      latitude: selectedStop.latitude,
      longitude: selectedStop.longitude,
      address: selectedStop.address,
      status: selectedStop.status,
      arrivalTime: selectedStop.arrivalTime,
      description: selectedStop.description,
      packages: [...selectedStop.packages, package],
    );

    upsertStop(originalStop: selectedStop, updatedStop: updatedStop);
    return true;
  }

  void upsertStop({required Stop originalStop, required Stop updatedStop}) {
    final selectedRoute = state.selectedRoute;
    if (selectedRoute == null) {
      state = state.copyWith(errorMessage: 'Ruta no seleccionada');
      return;
    }

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

    state = state.copyWith(
      selectedRoute: updatedRoute,
      selectedStop: null,
      routes: List<RouteEnt>.unmodifiable(updatedRoutes),
      errorMessage: '',
    );
  }

  void clearError() {
    if (state.errorMessage.isEmpty) return;
    state = state.copyWith(errorMessage: '');
  }

  Future<bool> updateStopStatus(Stop stop, StopStatus status) async {
    final selectedRoute = state.selectedRoute;
    final routeId = selectedRoute?.id ?? '';
    final stopId = stop.id ?? '';
    if (selectedRoute == null || routeId.isEmpty || stopId.isEmpty) {
      state = state.copyWith(errorMessage: 'Ruta o parada invalida');
      return false;
    }

    final updatedStop = _copyStopWithStatus(stop, status);

    try {
      state = state.copyWith(errorMessage: '');
      final response = await _stopRepository.editStop(routeId, updatedStop);
      if (response == null) {
        state = state.copyWith(errorMessage: 'No se pudo actualizar la parada');
        return false;
      }
      upsertStop(originalStop: stop, updatedStop: response);
      selectStop(response);
      state = state.copyWith(errorMessage: '');
      return true;
    } on ArgumentError catch (err) {
      state = state.copyWith(errorMessage: err.message);
      return false;
    } catch (_) {
      state = state.copyWith(errorMessage: 'No se pudo actualizar la parada');
      return false;
    }
  }

  Future<bool> deleteStop(Stop stop) async {
    final selectedRoute = state.selectedRoute;
    final routeId = selectedRoute?.id ?? '';
    final stopId = stop.id ?? '';
    if (selectedRoute == null || routeId.isEmpty || stopId.isEmpty) {
      state = state.copyWith(errorMessage: 'Ruta o parada invalida');
      return false;
    }

    try {
      state = state.copyWith(errorMessage: '');
      final deleted = await _stopRepository.deleteStop(routeId, stopId);
      if (!deleted) {
        state = state.copyWith(errorMessage: 'No se pudo eliminar la parada');
        return false;
      }

      final updatedStops = selectedRoute.stops
          .where((candidate) => !_isSameStopByIdOrFallback(candidate, stop))
          .toList();
      final updatedRoute = _copyRouteWithStops(selectedRoute, updatedStops);
      final updatedRoutes = state.routes
          .map((route) => route.id == updatedRoute.id ? updatedRoute : route)
          .toList();

      final selectedStop = state.selectedStop;
      final shouldClearSelected =
          selectedStop != null && _isSameStopByIdOrFallback(selectedStop, stop);

      state = state.copyWith(
        selectedRoute: updatedRoute,
        selectedStop: shouldClearSelected ? null : selectedStop,
        routes: List<RouteEnt>.unmodifiable(updatedRoutes),
        errorMessage: '',
      );
      return true;
    } on ArgumentError catch (err) {
      state = state.copyWith(errorMessage: err.message);
      return false;
    } catch (_) {
      state = state.copyWith(errorMessage: 'No se pudo eliminar la parada');
      return false;
    }
  }

  Future<bool> startSelectedRoute() async {
    final selectedRoute = state.selectedRoute;
    if (selectedRoute == null || selectedRoute.id.isEmpty) {
      state = state.copyWith(errorMessage: 'Ruta no seleccionada');
      return false;
    }

    final updatedRoute = _copyRouteWithState(selectedRoute, RouteState.started);

    try {
      state = state.copyWith(errorMessage: '');
      final response = await _routeRepository.updateRoute(updatedRoute);
      if (response == null) {
        state = state.copyWith(errorMessage: 'No se pudo iniciar la ruta');
        return false;
      }

      _updateRouteInState(response);
      _updateRouteInUser(response);
      return true;
    } on ArgumentError catch (err) {
      state = state.copyWith(errorMessage: err.message);
      return false;
    } catch (err) {
      state = state.copyWith(errorMessage: 'No se pudo iniciar la ruta');
      return false;
    }
  }

  Future<bool> completeSelectedRoute() async {
    final selectedRoute = state.selectedRoute;
    if (selectedRoute == null || selectedRoute.id.isEmpty) {
      state = state.copyWith(errorMessage: 'Ruta no seleccionada');
      return false;
    }

    final updatedRoute = _copyRouteWithState(
      selectedRoute,
      RouteState.completed,
    );

    try {
      state = state.copyWith(errorMessage: '');
      final response = await _routeRepository.updateRoute(updatedRoute);
      if (response == null) {
        state = state.copyWith(errorMessage: 'No se pudo finalizar la ruta');
        return false;
      }

      _updateRouteInState(response);
      _updateRouteInUser(response);
      return true;
    } on ArgumentError catch (err) {
      state = state.copyWith(errorMessage: err.message);
      return false;
    } catch (_) {
      state = state.copyWith(errorMessage: 'No se pudo finalizar la ruta');
      return false;
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

  Set<Polyline> _buildRoutePolylines(RouteEnt? route) {
    final encoded = route?.geometry;
    if (encoded == null || encoded.isEmpty) return const <Polyline>{};
    final points = _decodePolyline(encoded);
    if (points.isEmpty) return const <Polyline>{};

    return {
      Polyline(
        polylineId: PolylineId('route-${route?.id ?? 'selected'}'),
        points: points,
        color: const Color(0xFF1E88E5),
        width: 4,
      ),
    };
  }

  List<LatLng> _decodePolyline(String encoded) {
    PolylinePoints polylinePoints = PolylinePoints();
    final decoded = polylinePoints.decodePolyline(encoded);
    return decoded
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
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

  RouteEnt _copyRouteWithState(RouteEnt route, RouteState state) {
    return RouteEnt(
      id: route.id,
      name: route.name,
      geometry: route.geometry,
      creationDate: route.creationDate,
      completionDate: route.completionDate,
      state: state,
      stops: route.stops,
      returnAddress: route.returnAddress,
    );
  }

  Stop _copyStopWithStatus(Stop stop, StopStatus status) {
    if (stop is DeliveryStop) {
      return DeliveryStop(
        id: stop.id,
        latitude: stop.latitude,
        longitude: stop.longitude,
        address: stop.address,
        status: status,
        arrivalTime: stop.arrivalTime,
        closedTime: stop.closedTime,
        order: stop.order,
        description: stop.description,
        packages: stop.packages,
      );
    }
    if (stop is PickupStop) {
      return PickupStop(
        id: stop.id,
        latitude: stop.latitude,
        longitude: stop.longitude,
        address: stop.address,
        status: status,
        arrivalTime: stop.arrivalTime,
        closedTime: stop.closedTime,
        order: stop.order,
        description: stop.description,
      );
    }
    return stop;
  }

  void _updateRouteInState(RouteEnt updatedRoute) {
    final updatedRoutes = state.routes
        .map((route) => route.id == updatedRoute.id ? updatedRoute : route)
        .toList();

    state = state.copyWith(
      selectedRoute: updatedRoute,
      routes: List<RouteEnt>.unmodifiable(updatedRoutes),
    );
  }

  void _updateRouteInUser(RouteEnt updatedRoute) {
    final currentUser = _ref.read(authProvider).user;
    if (currentUser == null) return;

    final updatedRoutes = currentUser.routes
        .map((route) => route.id == updatedRoute.id ? updatedRoute : route)
        .toList();
    final updatedUser = currentUser.copyWith(routes: updatedRoutes);
    _ref.read(authProvider.notifier).updateUser(updatedUser);
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

      state.mapController?.animateCamera(
        CameraUpdate.newCameraPosition(state.cameraPosition),
      );
    } catch (_) {}
  }
}

class MapState {
  final List<RouteEnt> routes;
  final RouteEnt? selectedRoute;
  final Stop? selectedStop;
  final CameraPosition cameraPosition;
  final GoogleMapController? mapController;
  final Set<Polyline> polylines;
  final String errorMessage;

  MapState({
    this.routes = const [],
    this.selectedRoute,
    this.selectedStop,
    required this.cameraPosition,
    this.mapController,
    this.polylines = const <Polyline>{},
    this.errorMessage = '',
  });

  MapState copyWith({
    List<RouteEnt>? routes,
    RouteEnt? selectedRoute,
    Stop? selectedStop,
    CameraPosition? cameraPosition,
    GoogleMapController? mapController,
    Set<Polyline>? polylines,
    String? errorMessage,
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
    mapController: mapController ?? this.mapController,
    polylines: polylines ?? this.polylines,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
