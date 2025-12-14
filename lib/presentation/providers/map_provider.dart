import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/mocks/route_sample.dart';

final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  return MapNotifier();
});

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier() : super(MapState(routes: sampleRoutes));

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
}

class MapState {
  final List<RouteEnt> routes;
  final RouteEnt? selectedRoute;

  MapState({
    this.routes = const [],
    this.selectedRoute,
  });

  MapState copyWith({
    List<RouteEnt>? routes,
    RouteEnt? selectedRoute,
    bool clearSelection = false,
  }) => MapState(
    routes: routes ?? this.routes,
    selectedRoute:
        clearSelection ? null : (selectedRoute ?? this.selectedRoute),
  );
}
