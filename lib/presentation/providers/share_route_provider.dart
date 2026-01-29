import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';
import 'package:smart_route_app/presentation/providers/auth_provider.dart';
import 'package:smart_route_app/presentation/providers/map_provider.dart';

final shareRouteProvider =
    StateNotifierProvider<ShareRouteNotifier, ShareRouteState>(
      (ref) => ShareRouteNotifier(
        shareRouteRepository: ShareRouteRepositoryImpl(),
        ref: ref,
      ),
    );

class ShareRouteNotifier extends StateNotifier<ShareRouteState> {
  final IShareRouteRepository shareRouteRepository;
  final Ref<ShareRouteState> ref;

  ShareRouteNotifier({required this.shareRouteRepository, required this.ref})
    : super(const ShareRouteState());

  Future<String?> shareRoute(String routeId) async {
    if (routeId.isEmpty) {
      if (mounted) {
        state = state.copyWith(errorMessage: 'Ruta no seleccionada');
      }
      return null;
    }

    if (mounted) {
      state = state.copyWith(isSharing: true, errorMessage: '');
    }
    try {
      final result = await shareRouteRepository.shareRoute(routeId);
      if (result == null || result.isEmpty) {
        if (mounted) {
          state = state.copyWith(errorMessage: 'No se pudo compartir la ruta');
        }
        return null;
      }
      if (mounted) {
        state = state.copyWith(errorMessage: '');
      }
      return result;
    } on ArgumentError catch (err) {
      if (mounted) {
        state = state.copyWith(errorMessage: err.message);
      }
      return null;
    } catch (_) {
      if (mounted) {
        state = state.copyWith(errorMessage: 'No se pudo compartir la ruta');
      }
      return null;
    } finally {
      if (mounted) {
        state = state.copyWith(isSharing: false);
      }
    }
  }

  Future<RouteEnt?> acceptSharedRoute(String sharedRouteId) async {
    if (sharedRouteId.isEmpty) {
      if (mounted) {
        state = state.copyWith(errorMessage: 'Codigo de ruta compartida vacio');
      }
      return null;
    }

    if (mounted) {
      state = state.copyWith(isAccepting: true, errorMessage: '');
    }
    try {
      final result =
          await shareRouteRepository.acceptSharedRoute(sharedRouteId);
      if (result == null) {
        if (mounted) {
          state = state.copyWith(
            errorMessage: 'No se pudo aceptar la ruta compartida',
          );
        }
        return null;
      }
      _applyAcceptedRoute(result);
      if (mounted) {
        state = state.copyWith(errorMessage: '');
      }
      return result;
    } on ArgumentError catch (err) {
      if (mounted) {
        state = state.copyWith(errorMessage: err.message);
      }
      return null;
    } catch (_) {
      if (mounted) {
        state = state.copyWith(
          errorMessage: 'No se pudo aceptar la ruta compartida',
        );
      }
      return null;
    } finally {
      if (mounted) {
        state = state.copyWith(isAccepting: false);
      }
    }
  }

  void clearError() {
    if (state.errorMessage.isEmpty) return;
    if (mounted) {
      state = state.copyWith(errorMessage: '');
    }
  }

  void _applyAcceptedRoute(RouteEnt route) {
    final mapState = ref.read(mapProvider);
    final updatedMapRoutes = _upsertRoute(mapState.routes, route);
    ref.read(mapProvider.notifier).setRoutes(updatedMapRoutes);
    ref.read(mapProvider.notifier).selectRoute(route);

    final currentUser = ref.read(authProvider).user;
    if (currentUser != null) {
      final updatedUserRoutes = _upsertRoute(currentUser.routes, route);
      ref
          .read(authProvider.notifier)
          .updateUser(currentUser.copyWith(routes: updatedUserRoutes));
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

class ShareRouteState {
  final bool isSharing;
  final bool isAccepting;
  final String errorMessage;

  const ShareRouteState({
    this.isSharing = false,
    this.isAccepting = false,
    this.errorMessage = '',
  });

  ShareRouteState copyWith({
    bool? isSharing,
    bool? isAccepting,
    String? errorMessage,
  }) {
    return ShareRouteState(
      isSharing: isSharing ?? this.isSharing,
      isAccepting: isAccepting ?? this.isAccepting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
