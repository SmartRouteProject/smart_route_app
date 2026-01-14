import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';
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

  Future<RouteEnt?> onSubmit() async {
    final selectedRoute = ref.read(mapProvider).selectedRoute;
    final routeId = selectedRoute?.id ?? '';
    final origin = selectedRoute?.returnAddress;
    if (routeId.isEmpty || origin == null) return null;

    state = state.copyWith(optimizing: true);
    try {
      final request = OptimizationRequestDto(
        optimizeStopOrder: state.optimizeStops,
        origin: OptimizationOrigin(
          latitude: origin.latitude,
          longitude: origin.longitude,
        ),
      );

      return await optimizationRepository.optimizeRoute(routeId, request);
    } finally {
      state = state.copyWith(optimizing: false);
    }
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
