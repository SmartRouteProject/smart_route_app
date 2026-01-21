import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/infrastructure/infrastructure.dart';

final shareRouteProvider =
    StateNotifierProvider.autoDispose<ShareRouteNotifier, ShareRouteState>(
      (ref) => ShareRouteNotifier(
        shareRouteRepository: ShareRouteRepositoryImpl(),
      ),
    );

class ShareRouteNotifier extends StateNotifier<ShareRouteState> {
  final IShareRouteRepository shareRouteRepository;

  ShareRouteNotifier({required this.shareRouteRepository})
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

  Future<bool> acceptSharedRoute(String sharedRouteId) async {
    if (sharedRouteId.isEmpty) {
      if (mounted) {
        state = state.copyWith(errorMessage: 'Codigo de ruta compartida vacio');
      }
      return false;
    }

    if (mounted) {
      state = state.copyWith(isAccepting: true, errorMessage: '');
    }
    try {
      final result = await shareRouteRepository.acceptSharedRoute(
        sharedRouteId,
      );
      if (!result) {
        if (mounted) {
          state = state.copyWith(
            errorMessage: 'No se pudo aceptar la ruta compartida',
          );
        }
        return false;
      }
      if (mounted) {
        state = state.copyWith(errorMessage: '');
      }
      return true;
    } on ArgumentError catch (err) {
      if (mounted) {
        state = state.copyWith(errorMessage: err.message);
      }
      return false;
    } catch (_) {
      if (mounted) {
        state = state.copyWith(
          errorMessage: 'No se pudo aceptar la ruta compartida',
        );
      }
      return false;
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
