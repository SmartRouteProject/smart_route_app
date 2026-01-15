import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';
import 'package:smart_route_app/presentation/providers/auth_provider.dart';
import 'package:smart_route_app/presentation/providers/map_provider.dart';

final optimizationProvider =
    StateNotifierProvider.autoDispose<OptimizationNotifier, OptimizationState>(
      (ref) => OptimizationNotifier(
        optimizationRepository: OptimizationRepositoryImpl(),
        ref: ref,
      ),
    );

class OptimizationNotifier extends StateNotifier<OptimizationState> {
  final IOptimizationRepository optimizationRepository;
  final Ref<OptimizationState> ref;

  OptimizationNotifier({
    required this.optimizationRepository,
    required this.ref,
  }) : super(const OptimizationState());

  void setOptimizeStops(bool value) {
    if (value == state.optimizeStops) return;
    state = state.copyWith(optimizeStops: value);
  }

  Future<bool> onSubmit() async {
    final selectedRoute = ref.read(mapProvider).selectedRoute;
    final routeId = selectedRoute?.id ?? '';
    if (routeId.isEmpty) return false;

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    state = state.copyWith(optimizing: true);
    try {
      final request = OptimizationRequestDto(
        optimizeStopOrder: state.optimizeStops,
        origin: OptimizationOrigin(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );

      final result = await optimizationRepository.optimizeRoute(
        routeId,
        request,
      );
      if (result == null) return false;

      final mapState = ref.read(mapProvider);
      final updatedMapRoutes = _upsertRoute(mapState.routes, result);
      ref.read(mapProvider.notifier).setRoutes(updatedMapRoutes);
      ref.read(mapProvider.notifier).selectRoute(result);

      final currentUser = ref.read(authProvider).user;
      if (currentUser != null) {
        final updatedUserRoutes = _upsertRoute(currentUser.routes, result);
        ref
            .read(authProvider.notifier)
            .updateUser(currentUser.copyWith(routes: updatedUserRoutes));
      }

      return true;
    } finally {
      state = state.copyWith(optimizing: false);
    }
  }

  List<RouteEnt> _upsertRoute(List<RouteEnt> routes, RouteEnt updatedRoute) {
    var replaced = false;
    final updatedRoutes = routes.map((route) {
      if (route.id == updatedRoute.id) {
        replaced = true;
        return updatedRoute;
      }
      return route;
    }).toList();
    if (!replaced) {
      updatedRoutes.add(updatedRoute);
    }
    return List<RouteEnt>.unmodifiable(updatedRoutes);
  }
}

class OptimizationState {
  final bool optimizeStops;
  final bool optimizing;

  const OptimizationState({this.optimizeStops = true, this.optimizing = false});

  OptimizationState copyWith({bool? optimizeStops, bool? optimizing}) {
    return OptimizationState(
      optimizeStops: optimizeStops ?? this.optimizeStops,
      optimizing: optimizing ?? this.optimizing,
    );
  }
}
